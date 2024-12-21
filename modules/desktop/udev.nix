{pkgs, config, lib, ...}: {
  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-794l"
  ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nrf-command-line-tools"
     "segger-jlink"
  ];
  nixpkgs.config.segger-jlink.acceptLicense = true;
  environment.systemPackages = with pkgs; [ 
    #nrf-command-line-tools
  ];
  services.udev.extraRules = (builtins.readFile ../../dotfiles/60-openocd.rules);
}
