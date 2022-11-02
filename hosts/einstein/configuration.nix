{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
  ];

  boot = {
    loader = {
      grub.enable = false;
      #raspberryPi = {
      #  enable = true;
      #  version = 3;
      #  uboot.enable = true;
      #};
    };
    kernelPackages = pkgs.linuxPackages_latest;
    # No ZFS on latest kernel:
    tmpOnTmpfs = true;
  };

  time.timeZone = "Europe/Berlin";

  programs.tmux.enable = true;

  # Do not log to flash:
  services.journald.extraConfig = ''
    Storage=volatile
  '';

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  system.stateVersion = "22.05";
}

