{ lib, ... }:
{
  imports = [
    #./hardware-configuration.nix
    ./network.nix
    ./rpi-3b-4b.nix
  ];

  #imports = [
  #  (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  #];

  boot = {
    supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];
  };

  time.timeZone = "Europe/Berlin";

  # Do not log to flash:
  services.journald.extraConfig = ''
    Storage=volatile
  '';

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  system.stateVersion = "22.05";

}

