{ pkgs, config, ... }: {

  imports = [
    ./sops.nix
    ./nginx.nix
  ];

  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      ../../keys/ssh/revol-xut
    ];
  };

  nix = {
    package = pkgs.nixUnstable;
    settings = {
      auto-optimise-store = true;
      #substitutes = [
      #  "https://hydra.hq.c3d2.de"
      #];
      #thrusted-public-keys = [
      #  "hydra.hq.c3d2.de:KZRGGnwOYzys6pxgM8jlur36RmkJQ/y8y62e52fj1ps="
      #];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      allow-import-from-derivation = true
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    git
    htop
    tmux
    vim_configurable
    wget
    neovim
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  programs.mosh.enable = true;
}
