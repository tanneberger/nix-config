{ pkgs, ... }: {
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # p
  services.blueman.enable = true;
  #hardware.bluetooth.enable = true;
  #services.blueman.enable = true;
}
