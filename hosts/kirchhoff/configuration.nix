{ pkgs, config, lib, ... }: {

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

    supportedFilesystems = [ "zfs" "ntfs" ];
    zfs.devNodes = "/dev/";
    zfs.requestEncryptionCredentials = true;
  };

  #boot.kernel.sysctl."kernel.perf_event_paranoid" = 1;
  hardware.enableRedistributableFirmware = true;

  nix = {
    settings.cores = 0;
    settings.max-jobs = 6;
    buildMachines = [
      {
        hostName = "hydra.serv.zentralwerk.org";
        sshUser = "root";
        system = "x86_64-linux";
        sshKey = "/home/revol-xut/.ssh/id_rsa";
        supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
        speedFactor = 5;
        maxJobs = 10;
      }
      /*{
        hostName = "server7.cluster.zentralwerk.org";
        sshUser = "root";
        system = "x86_64-linux";
        sshKey = "/home/revol-xut/.ssh/id_rsa";
        supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
        speedFactor = 6;
        maxJobs = 10;
      }*/

    ];


    distributedBuilds = true;
    settings = {
      sandbox = false;
    };
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
  services.gvfs.enable = true;

  security.rtkit.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluez;
  services.blueman.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];
  # For 32 bit applications 
  # Only available on unstable
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  boot.binfmt.emulatedSystems = [ "riscv32-linux" ];
  services.udev.extraRules = ''
    # MCH2022 Badge
    SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="0f9a", MODE="0666"

    #Flipper Zero serial port
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
    #Flipper Zero DFU
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", TAG+="uaccess"
    #Flipper ESP32s2 BlackMagic
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="40??", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess"
  '';

  #services.thinkfan = {
  #  enable = true;
  #};

  services.zfs = {
    autoSnapshot = {
      enable = true;
      frequent = 4;
      hourly = 6;
      daily = 6;
      weekly = 2;
      monthly = 1;
    };
    autoScrub.enable = true;
    trim.enable = true;
  };

  programs.nix-ld.enable = true;

  system.stateVersion = "22.05"; # Did you read the comment?
}

