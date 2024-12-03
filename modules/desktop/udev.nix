{pkgs, config, lib, ...}: {
  services.udev.extraRules = (builtins.readFile ../../dotfiles/60-openocd.rules);
}
