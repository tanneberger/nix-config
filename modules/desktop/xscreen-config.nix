{ pkgs, config, ... }: {
  # on boot it just executes the following command 
  services.xserver.displayManager.setupCommands = ''
    MAIN='DisplayPort-0'
    LEFT='DisplayPort-2'
    ${pkgs.xorg.xrandr}/bin/xrandr --output $MAIN --left-of $LEFT
  '';


  # Testing it with autorandr
  home-manager.users.revol-xut.programs.autorandr = {
    enable = false;
    profiles = {
      "desktop" = {
        fingerprint = {
          "DisplayPort-0" = "00ffffffffffff000472c90650d30092141d0104b53c22783f0c95ab554ca0240d5054bfef80714f8140818081c081009500b300d1c0565e00a0a0a029503020350055502100001a000000fd00304b70701e010a202020202020000000fc005647323730550a202020202020000000ff005445484545303034383532410a0172020318f14b010203040590111213141f23090707830100009774006ea0a034501720680855502100001a2a4480a0703827403020350055502100001a023a801871382d40582c450055502100001e011d8018711c1620582c250055502100009e011d007251d01e206e28550055502100001e0000000000000000000000000040";
          "DisplayPort-2" = "00ffffffffffff000472c9065bd30092141d0104b53c22783f0c95ab554ca0240d5054bfef80714f8140818081c081009500b300d1c0565e00a0a0a029503020350055502100001a000000fd00304b70701e010a202020202020000000fc005647323730550a202020202020000000ff005445484545303034383532410a0167020318f14b010203040590111213141f23090707830100009774006ea0a034501720680855502100001a2a4480a0703827403020350055502100001a023a801871382d40582c450055502100001e011d8018711c1620582c250055502100009e011d007251d01e206e28550055502100001e0000000000000000000000000040";
        };
        config = {
          "DisplayPort-0" = {
            enable = false;
            primary = true;
            position = "2560x0";
            mode = "2560x1440";
          };

          "DisplayPort-1" = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "2560x1440";
          };

          "DisplayPort-2" = {
            enable = true;
            primary = false;
            position = "2560x0";
            mode = "2560x1440";
          };
        };
      };
    };
  };
}



