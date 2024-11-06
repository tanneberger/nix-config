{ pkgs, config, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  sops.defaultSopsFile = ../../secrets/kirchhoff.yaml;

  boot = {
    initrd.kernelModules = [ "amdgpu" "ext4" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelParams = [ "nohibernate" ];

    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "zfs" ];
    zfs.devNodes = "/dev/";
    zfs.requestEncryptionCredentials = true;
  };

  nix = {
    settings = {
      cores = 0;
      max-jobs = 6;
    };

    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  services = {
    udisks2.enable = true;
  };

  security.rtkit.enable = true;

  hardware = {
    enableRedistributableFirmware = true;

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        driversi686Linux.amdvlk
        amdvlk
      ];
      driSupport = true;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  systemd.services."usb-mount@" = {
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.coreutils-full}/bin/mount -m /dev/%i /media/tanneberger/%i
      ${pkgs.coreutils-full}/bin/chown -R tanneberger /media/tanneberger/%i
    '';
  };

  #boot.binfmt.emulatedSystems = [ "riscv32-linux" ];

  services.udev.extraRules = ''
    # MCH2022 Badge
    SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="0f9a", MODE="0666"

    #Flipper Zero serial port
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
    #Flipper Zero DFU
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", TAG+="uaccess"
    #Flipper ESP32s2 BlackMagic
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="40??", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"

    KERNEL=="sd[a-z][0-9]", SUBSYSTEMS=="usb", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemctl --no-block start usb-mount@%k.service" KERNEL=="sd[a-z][0-9]", SUBSYSTEMS=="usb", ACTION=="remove", RUN+="${pkgs.systemd}/bin/systemctl --no-block stop usb-mount@%k.service"
  '';

  services.zfs = {
    autoSnapshot = {
      enable = true;
      frequent = 1;
      hourly = 1;
      daily = 1;
      weekly = 1;
      monthly = 1;
    };
    autoScrub.enable = true;
    trim.enable = true;
  };

  system.stateVersion = "24.05";
}

