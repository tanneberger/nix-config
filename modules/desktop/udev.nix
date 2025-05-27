{ pkgs, config, lib, ... }:
let
  udev-saleae = pkgs.stdenv.mkDerivation {
    name = "udev-saleae";

    src = ../../dotfiles/.;

    installPhase = ''
      mkdir -p $out/lib/udev
    '';

    postInstall = ''
      install -D $out/lib/udev/rules.d 90-saleae-logic.rules
    '';
  };
in
{
  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-794l"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nrf-command-line-tools"
    "segger-jlink"
    "saleae-logic"
    "saleae-logic-2"
  ];
  nixpkgs.config.segger-jlink.acceptLicense = true;
  services.udev.enable = true;
  services.udev.extraRules = ((builtins.readFile ../../dotfiles/60-openocd.rules) + ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1005", MODE="0777"
  '');

  services.udev.packages = [ pkgs.saleae-logic-2 udev-saleae ];
}
