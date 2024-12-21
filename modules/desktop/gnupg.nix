{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    opensc
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization
    yubikey-personalization-gui
  ];

  # smartcard support
  services = {
    pcscd = {
      enable = true;
    };
    yubikey-agent = {
      enable = true;
    };
  };
  hardware.gpgSmartcards.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
    enableBrowserSocket = true;
    #enableBashIntegration = true;
    #pinentryFlavor = "gnome3";
    pinentryPackage = pkgs.pinentry-curses;
  };
}
