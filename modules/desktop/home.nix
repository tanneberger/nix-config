{ config, pkgs, lib, ... }: {

  imports = [
    ./neomutt.nix
  ];
  home.username = "tanneberger";
  home.homeDirectory = "/home/tanneberger";
  home.stateVersion = "24.05";

  # Allow clion as unfree package
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "clion"
    "pycharm-community"
    "steam"
    "steam-original"
    "zoom"
    "vscode"
    "phpstorm"
  ];

  home.packages = with pkgs; [
    inxi # system information 
    gcc # gnu compiler collection
    libgcc
    gcovr
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
    unzip # extracting zip files
    zx # extracting .xz files
    marktext # markdown editor 
    pulsemixer # better pavucontrol
    #pass # password manager
    #passExtensions.pass-otp
    ncmpcpp # console music player
    calcurse # calender tool
    btop # improved htop
    qutebrowser # superiour vim browser
    tdesktop # normal telegram desktop
    # pdfpc # tool for presentations TODO: borked
    #lynx # text based browser
    gopher # very nice 1900s protocoll
    openvpn # vpn software
    w3m # minimal webbrowser for reading html mails
    notmuch # mail indexing
    notmuch-mutt # notmuch integration for mutt
    isync # email sync
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
    sops # secrets manager

    # networking tools
    traceroute # traceroute for networking debugging
    dig # tool for debugging dns 
    mtr # networking diagnostics
    ipcalc # calculating ip addresses
    nmap # our favorite port scanner
    ethtool # get information about link
    arp-scan # get layer 1 information
    minicom # serial console
    ipcalc # tool to calculate ip prefixes
    tcpdump # watching netdevs
    mtr # better traceroute
    whois # whois tooling
    pciutils # checking connected pcidevices
    usbutils # lsusb
    rsync # file transfer
    wdisplays # configuring wayland displays
    texmaker
    #clang

    #rustup

    # rust development
    #cargo
    #rustc
    rustup
    #clippy # linter and smell checker
    #rustfmt # auto-formatter
    gef
    # rust-analyzer
    # rust-analyzer-unwrapped

    # spelling
    aspell
    aspellDicts.de
    aspellDicts.en
    # cpp development
    cmake
    inspectrum
    gqrx
    #jetbrains.clion
    #jetbrains.pycharm-community
    #cpplint
    #llvm
    gdb
    rr
    #cgdb

    terminus-nerdfont
    vscode
    yarn
    inkscape
    zotero
    kicad
  ];
  programs.gpg = {
    enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
    };
    # ssh-agent.enable = true;
  };

  programs = {
    nixvim.enable = true;
    fzf.enable = true; # fuzzy finder 
    alacritty = {
      enable = true;
    };
    ssh = {
      forwardAgent = true;
      enable = true; # ssh
      matchBlocks = {
        "redneck" = {
          hostname = "128.32.171.201";
          user = "redneck";
        };
        "tanneberger" = {
          hostname = "tanneberger.me";
          user = "root";
          forwardAgent = true;
        };
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
      userName = "tanneberger";
      userEmail = "github@tanneberger.me";

      signing = {
        key = "91EBE87016391323642A6803B966009D57E69CC6";
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
      history.save = 1000000;
      autocd = true;
      shellAliases = {
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
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word

        autoload -U promptinit; promptinit

        # change the path color
        zstyle :prompt:pure:git:branch color red
        prompt bart

        export PNPM_HOME="/home/tanneberger/.local/share/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
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
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
  };
}

