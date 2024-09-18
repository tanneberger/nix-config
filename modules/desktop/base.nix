{ config, pkgs, lib, ... }:
{
  imports = [
    ./certs.nix
    ./dvb-dump-nfs-automount.nix
    ./pipewire.nix
    ./mpd.nix
    ./mail.nix
    ./docker.nix
  ];

  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "clion"
    "rust-rover"
    "webstorm"
    "zoom"
    "zoom-us"
    "minecraft-launcher"
    "prismlauncher"
    "vscode"
    "obsidian"
    "discord"
    "phpstorm"
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "segger-jlink-qt4-794l"
  ];

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.segger-jlink.acceptLicense = true;

  #boot = {
  #  binfmt.emulatedSystems = [ "aarch64-linux" "armv6l-linux" ];
  #};

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
      "networkmanager"
      "docker"
      "vboxusers"
      "storage"
    ];
    initialPassword = "start_default_password_9#2";
    shell = pkgs.zsh;
  };

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  environment.sessionVariables = { GTK_THEME = "Adwaita:dark"; };

  nix = {
    package = pkgs.nixVersions.latest;
    nixPath = [
      "nixpkgs=${pkgs.path}"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
    settings = {
      auto-optimise-store = true;
      #substituters = [
      #  "https://dump-dvb.cachix.org"
      #  "https://nix-cache.hq.c3d2.de"
      #];
      #trusted-public-keys = [
      #  "dump-dvb.cachix.org-1:+Dq7gqpQG4YlLA2X3xJsG1v3BrlUGGpVtUKWk0dTyUU="
      #  "nix-cache.hq.c3d2.de:KZRGGnwOYzys6pxgM8jlur36RmkJQ/y8y62e52fj1ps="
      #];
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
    #yubikey-agent = {
    #  enable = true;
    #};
    weechat = {
      enable = true;
    };
    udev.packages = [ pkgs.yubikey-personalization ];
    tlp = {
      #enable = true;
      settings = {
        "USB_BLACKLIST" = "1d50:604b 1d50:6089 1d50:cc15 1fc9:000c";
      };
    };

  };
  fonts.fontconfig = {
    enable = true;
  };
  fonts.packages = with pkgs; [
    dejavu_fonts
    font-awesome
    stix-two
    stix-otf
    open-sans
  ];

  environment.systemPackages = let 

    pythonEnv = pkgs.python312.withPackages (p: with p; [
      pyserial
    ]);

  in with pkgs; [
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
    wpa_supplicant_gui
    jq # json tool
    qFlipper # tool for flipper zero

    slurp # screenshotting
    grim # screenshotting
    texlive.combined.scheme-full
    emacs
    #unstable.zoom-us
    zoom-us
    pythonEnv

    termusic # nice music player
    nix-output-monitor # fancy output  for nix build

    # different common fonts for icons 
    dejavu_fonts
    font-awesome
    font-awesome_5
    unicode-emoji
    jetbrains.clion
    jetbrains.rust-rover
    jetbrains.webstorm
    typst
    discord
    neovim
    firefox
    direnv
    #(nix-direnv.override { enableFlakes = true; })
    nix-direnv
    chromium
    gdb
    binutils-unwrapped-all-targets
    minecraft
    shikane
    imagemagick
    openssl
    pkg-config
    nodePackages_latest.pnpm
    passExtensions.pass-genphrase
    passExtensions.pass-import
    passExtensions.pass-otp
    passExtensions.pass-tomb
    passExtensions.pass-update
    (pass.withExtensions (ext: with ext; [ pass-otp pass-import pass-genphrase pass-update pass-tomb ]))
    jdk17
    fontconfig
    ripgrep

    fenix.stable.completeToolchain
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

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };
}

