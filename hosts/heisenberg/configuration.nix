{ pkgs, config, lib, ... }: {

  imports = [
    ./heisenberg-hardware.nix
    ./network.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader.grub.device = "/dev/sda";
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;
  };
  nix.settings.buildCores = 8;
  programs.iftop.enable = true;
  services.upower.enable = true;
  services.acpid.enable = true;

  networking.hostName = "heisenberg";

  nix = {
    buildMachines = [
      {
        hostName = "hydra.hq.c3d2.de";
        sshUser = "root";
        system = "x86_64-linux";
        sshKey = "/home/revol-xut/.ssh/id_rsa";
        supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
        speedFactor = 10;
        maxJobs = 10;
      }
    ];

    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  sops.defaultSopsFile = ../../secrets/heisenberg.yaml;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.fstrim.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  services.zfs = {
    # TODO: configure auto snapshotting
    autoSnapshot.enable = true;
    autoScrub.enable = true;
  };
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  services.openssh.enable = true;

  system.stateVersion = "22.05";
}

