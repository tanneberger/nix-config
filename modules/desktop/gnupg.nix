{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    opensc
    #yubikey-manager
    #yubikey-manager-qt
    yubikey-personalization
    yubioath-flutter
  ];

  # smartcard support
  services = {
    pcscd = {
      enable = true;
    };
    yubikey-agent = {
      #enable = true; // this fucker set the SSH_AUTH_KEY
    };
  };
  hardware.gpgSmartcards.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
    enableBrowserSocket = true;
    #enableBashIntegration = true;
    #pinentryFlavor = "gtk2";
    #pinentryPackage = pkgs.pinentry-curses;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  programs.ssh.startAgent = false;

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null
  '';
}
