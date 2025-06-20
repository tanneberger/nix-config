{ config, pkgs, lib, ... }:
let
  berkeley-mono = pkgs.callPackage ../../pkgs/berkeley-mono.nix { };
in
{
  imports = [
    ./certs.nix
    ./pipewire.nix
    ./mail.nix
    ./docker.nix
    ./udev.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "clion"
    "idea-ultimate"
    "rust-rover"
    "webstorm"
    "zoom"
    "zoom-us"
    "prismlauncher"
    "vscode"
    "discord"
    "steam-unwrapped"
    "nrf-command-line-tools"
    "segger-jlink"
    "saleae-logic"
    "saleae-logic-2"
  ];

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "de_DE.UTF-8/UTF-8"
  ];

  time.timeZone = "Europe/Berlin";

  users.users.tanneberger = {
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
      "qemu-libvirtd"
    ];
    initialPassword = "start_default_password_9#2";
    shell = pkgs.zsh;
  };

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  environment.sessionVariables = { GTK_THEME = "Adwaita:dark"; };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ libelf ];
  nix = {
    package = pkgs.nixVersions.latest;
    nixPath = [
      "nixpkgs=${pkgs.path}"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
    settings = {
      auto-optimise-store = true;
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
    udev.packages = [ pkgs.yubikey-personalization ];
    tlp = {
      #enable = true;
      settings = {
        "USB_BLACKLIST" = "1d50:604b 1d50:6089 1d50:cc15 1fc9:000c";
      };
    };

  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Liberation Serif" ];
        sansSerif = [ "Ubuntu" "Vazirmatn" ];
        monospace = [ "Berkeley Mono Trial" ];
      };
    };
    packages = with pkgs; [
      dejavu_fonts
      font-awesome
      stix-two
      stix-otf
      open-sans
      berkeley-mono
    ];
  };

  # needed for gnome file viewer (nautilus)
  services.gvfs.enable = true;

  environment.systemPackages =
    let
      pythonEnv = pkgs.python312.withPackages (p: with p; [
        pyserial
      ]);
    in
    with pkgs; [
      git # versioning tool
      vim # vim editor
      htop # resource monitor
      acpi # battery stuff
      home-manager # managing homespace and user software
      alsa-utils # audio control
      pinentry # password entry window required for gpg
      dconf # required by paprefs
      nix-index # indexing nix packages
      mpd # music player daemon
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
      zoom-us
      pythonEnv
      udiskie
      nodejs
      ninja

      termusic # nice music player
      nix-output-monitor # fancy output  for nix build

      # different common fonts for icons 
      unicode-emoji
      jetbrains.clion
      jetbrains.idea-ultimate
      jetbrains.rust-rover
      jetbrains.webstorm
      discord
      neovim
      firefox
      direnv
      nix-direnv
      chromium
      gdb
      binutils-unwrapped-all-targets
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
      fontconfig
      openjdk17-bootstrap
      font-manager # this is required for the lf vscode extension to work
      ripgrep
      fenix.stable.completeToolchain
      nautilus
      kdePackages.dolphin
      keepassxc
      lutris
      saleae-logic-2
      qemu
      verilator
      sbt
      scala-cli
      scala 
      mill
    ];

  hardware = {
    hackrf.enable = true;
    rtl-sdr.enable = true;
  };

  virtualisation.libvirtd = {
    qemu = {
      package = pkgs.qemu_kvm; # only emulates host arch, smaller download
      swtpm.enable = true; # allows for creating emulated TPM
    };
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
  services.blueman.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;
}

