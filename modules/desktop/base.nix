{ config, pkgs, lib, options, ... }:
{
  imports = [
    ./docker.nix
    ./certs.nix
    ./dvb-dump-nfs-automount.nix
    ./pipewire.nix
    ./weechat.nix
    ./xscreen-config.nix
    ./mpd.nix
    ./mail.nix
  ];

  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "steam"
    "steam-original"
    "clion"
    "idea-ultimate"
    "zoom"
    "minecraft-launcher"
    "prismlauncher"
    "vscode"
    "obsidian"
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" "armv6l-linux" ];
    #kernelPackages = pkgs.linuxKernel.packages.linux_5_15;
  };

  time.timeZone = "Europe/Berlin";

  users.users.revol-xut = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "wireshark"
      "video"
      "libvirtd"
      "plugdev"
      "dialout"
      "bluetooth"
      "audio"
    ];
    initialPassword = "start_default_password_9#2";
    shell = pkgs.zsh;
  };

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  environment.sessionVariables = { GTK_THEME = "Adwaita:dark"; };

  nix = {
    package = pkgs.nixUnstable;
    nixPath = [
      "nixpkgs=${pkgs.path}"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://dump-dvb.cachix.org"
        #"https://nix-serve.hq.c3d2.de"
      ];
      trusted-public-keys = [
        "dump-dvb.cachix.org-1:+Dq7gqpQG4YlLA2X3xJsG1v3BrlUGGpVtUKWk0dTyUU="
        #"nix-serve.hq.c3d2.de:KZRGGnwOYzys6pxgM8jlur36RmkJQ/y8y62e52fj1ps="
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      allow-import-from-derivation = true
    '';
  };

  services = {
    accounts-daemon.enable = true;
    printing.enable = true;
    illum.enable = true;
    yubikey-agent = {
      enable = true;
    };
    weechat = {
      enable = true;
    };
    udev.packages = [ pkgs.yubikey-personalization ];
    tlp = {
      enable = true;
      settings = {
        "USB_BLACKLIST" = "1d50:604b 1d50:6089 1d50:cc15 1fc9:000c";
      };
    };

  };
  fonts.fontconfig = {
    enable = true;
  };
  fonts.fonts = with pkgs; [
    dejavu_fonts
    font-awesome
    font-awesome_5
    nerdfonts
  ];

  environment.systemPackages = with pkgs; [
    git # versioning tool
    vim # vim editor
    htop # resource monitor
    acpi # battery stuff
    home-manager # managing homespace and user software
    alsa-utils # audio controll
    pinentry # password entry window required for gpg
    dconf # required by paprefs
    nix-index # indexing nix packages
    mpd # music player deamon
    openssl
    libtool
    glibc
    libsForQt5.kcachegrind
    steam # gaming
    prusa-slicer
    gqrx # radio tooling
    hackrf # hackrf slides
    rtl-sdr # lib rtl-sdr
    # barrel # lingua-franca tool
    wpa_supplicant_gui
    jq # json tool
    qFlipper # tool for flipper zero

    slurp # screenshotting
    grim # screenshotting
    texlive.combined.scheme-full
    jetbrains.idea-ultimate
    emacs

    termusic # nice music player
    nix-output-monitor # fancy output  for nix build

    # different common fonts for icons 
    dejavu_fonts
    font-awesome
    font-awesome_5
    unicode-emoji
    jetbrains.clion
    jetbrains.pycharm-community

    typst
    discord
    neovim
    firefox-wayland
    direnv
    (nix-direnv.override { enableFlakes = true; })
    chromium
    gdb
    binutils-unwrapped-all-targets
    minecraft
    shikane
  ];

  hardware = {
    hackrf.enable = true;
    rtl-sdr.enable = true;
  };

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  ## direnv
  programs.bash.interactiveShellInit = ''eval "$(direnv hook bash)"'';

  environment.shellInit = ''export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
  '';
  #environment.shellInit = ''
  #  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  #'';

  programs = {
    mosh.enable = true;
    zsh = {
      enable = true;
      interactiveShellInit = ''eval "$(direnv hook zsh)"'';
    };
    vim.defaultEditor = true;
    neovim = {
      viAlias = true;
      vimAlias = true;
    };
    ssh = {
      startAgent = false;
    };
  };
}

