{ config, pkgs, lib, ... }: {

  imports = [
    ./dotfiles.nix
    ./neomutt.nix
  ];
  home.username = "revol-xut";
  home.homeDirectory = "/home/revol-xut";
  home.stateVersion = "22.05";

  # Allow clion as unfree packag
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "clion"
    "pycharm-community"
    "steam"
    "steam-original"
    "zoom"
  ];

  home.packages = with pkgs; [
    inxi # system information 
    gcc # gnu compiler collection
    nixpkgs-fmt # formatting for nix configs
    dmenu # menu stuff
    pamixer # cli sound mixer
    mpc_cli # music player console version
    mpv # console music player
    paprefs # network audio 
    pavucontrol # audio controll
    okular # pdf viewer
    feh # background and image viewer
    gnumake # makefiles
    arandr # x configuration
    gajim # xmpp client
    dino # better than gajim
    glow # markdown cli render
    hexyl # hex editor
    abook # address book for neomutt
    lf # file explorer
    newsboat # rss feed reader 
    unzip # extracting zip files
    zx # extracting .xz files
    marktext # markdown editor 
    pulsemixer # better pavucontrol
    pass # password manager
    ncmpcpp # console music player
    calcurse # calender tool
    btop # improved htop
    qutebrowser # superiour vim browser
    tdesktop # normal telegram desktop
    slack-term # terminal client for slack (REMOVE Weechat)
    # pdfpc # tool for presentations TODO: borked
    #lynx # text based browser
    gopher # very nice 1900s protocoll
    openvpn # vpn software
    w3m # minimal webbrowser for reading html mails
    notmuch # mail indexing
    notmuch-mutt # notmuch integration for mutt
    isync # email sync
    weechat # minimal terminal irc and matrix client
    dino # better xmpp client
    silver-searcher # pretty alternative to rgrep
    tree # prinint tree of directory
    signal-desktop
    fd # quick find
    alacritty # terminal emulator
    zotero # library managment
    thunderbird # email client
    zathura # minimal pdf viewer
    bat # is cat but nicer
    blueberry # bluetooth manager
    zoom-us

    # networking tools
    traceroute # traceroute for networking debugging
    dig # tool for debugging dns 
    mtr # networking diagnostics
    ipcalc # calculating ip addresses
    nmap # our favorite port scanner
    ethtool # get information about link
    arp-scan # get layer 1 information

    pciutils # checking connected pcidevices
    usbutils # lsusb

    rsync # file transfer
    pure-prompt # fancy prompt
    wdisplays # configuring wayland displays
    texmaker
    # rustup

    # rust development
    # cargo
    # rustc
    # clippy # linter and smell checker
    # rustfmt # auto-formatter
    gef
    # rust-analyzer
    # rust-analyzer-unwrapped

    # spelling
    aspell
    aspellDicts.de
    aspellDicts.en
    python39
    # cpp development
    cmake
    #jetbrains.clion

    jetbrains.idea-community
    inspectrum 
    gqrx
    #jetbrains.clion
    #jetbrains.pycharm-community
    #cpplint
    #llvm
    #gdb
    #cgdb
  ];

  programs = {
    fzf.enable = true; # fuzzy finder 
    alacritty = {
      enable = true;
    };
    ssh = {
      forwardAgent = true;
      enable = true; # ssh
      matchBlocks = {
        "espresso" = {
          hostname = "espresso.ascii.coffee";
          user = "root";
          forwardAgent = true;
        };
        "latte" = {
          hostname = "10.3.142.2";
          user = "root";
          extraOptions = {
            "ProxyJump" = "root@espresso.ascii.coffee";
          };
        };
        "kaki" = {
          hostname = "kaki.ifsr.de";
          user = "root";
        };
        "tassilo" = {
          hostname = "tassilo-tanneberger.de";
          user = "revol-xut";
          port = 1025;
        };
        "traffic-box-box" = {
          hostname = "10.13.37.100";
          user = "root";
          forwardAgent = true;
        };
        "data-hoarder" = {
          hostname = "10.13.37.1";
          user = "root";
          forwardAgent = true;
        };
        "schroedinger" = {
          hostname = "88.198.121.105";
          user = "root";
          forwardAgent = true;
        };
        "c3d2" = {
          hostname = "c3d2.de";
          user = "root";
          forwardAgent = true;
        };
        "quitte" = {
          hostname = "141.30.30.169";
          user = "root";
          forwardAgent = true;
        };
      };
    };
    neomutt.enable = true; # mail client

    git = {
      # versioning program
      enable = true;
      userName = "revol-xut";
      userEmail = "revol-xut@protonmail.com";

      signing = {
        key = "91EBE87016391323642A6803B966009D57E69CC6";
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      history.save = 1000000;
      autocd = true;
      shellAliases = {
        clion = "export _JAVA_AWT_WM_NONREPARENTING=1 && clion";
        calcurse-caldav = "CALCURSE_CALDAV_PASSWORD=$(pass show radicale/revol-xut) calcurse-caldav";
        calendar = "calcurse-caldav --init=keep-remote  && calcurse && calcurse-caldav --init=keep-local";
        browser = "export USE_WOLFRAM_LD_LIBRARY_PATH=1 && export QT_XCB_GL_INTEGRATION=none && qutebrowser";
        idea-ultimate = "export _JAVA_AWT_WM_NONREPARENTING=1 && idea-ultimate";
        ccc-slack = "slack-term --config ~/.config/slack-term/ccc-config";
        lf-slack = "slack-term --config ~/.config/slack-term/lf-lang-config";
        update = "sudo nixos-rebuild switch";
        update-full = "nix flake update && sudo nixos-rebuild switch";
        ga = "git add -A";
        gc = "git commit -S -m";
        gp = "git push";
        goto = "cd ~/workspace/ && cd";
        deepclean = "sudo nix-store --gc --print-roots | command grep -E -v -e \"^(/nix/var|/run/\w+-system|\{(memory|temp)|/proc/)\" -e \"flake-registry.json$\"| awk '{print $1}' | xargs -I{} bash -c 'echo \"Removing {}...\"; rm -f {}'";
        l = "${pkgs.lsd}/bin/lsd -Alh --date relative";
        ls = "${pkgs.lsd}/bin/lsd";
        mo = "${pkgs.mosh}/bin/mosh";
        ip = "${pkgs.iproute2}/bin/ip -color";
        v = "${pkgs.neovim}/bin/nvim";
        vim = "${pkgs.neovim}/bin/nvim";
      };
      initExtra = ''
        autoload -U promptinit; promptinit

        # change the path color
        zstyle :prompt:pure:git:branch color red
        prompt pure
      '';
    };

    starship = {
      # prompt
      enable = false;
      enableZshIntegration = true;
      settings = {
        add_newline = false;

        character = {
          success_symbol = "[λ](bold green)";
          error_symbol = "[λ](bold red)";
        };
      };
    };
  };
}

