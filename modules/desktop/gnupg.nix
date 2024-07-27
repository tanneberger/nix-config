{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    opensc

    #yubikey-personalization-gui
  ];

  # smartcard support
  # services.pcscd.enable = false;
  #hardware.gpgSmartcards.enable = true;
  #programs.gpg = {
  #    enable = true;
  #};
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
    #enableBashIntegration = true;
    #pinentryFlavor = "gnome3";
    pinentryPackage = pkgs.pinentry-curses;
  };
}
