{ pkgs, config, ... }: {
  services = {
    xserver = {
      enable = true;
      libinput.enable = true;
      dpi = 60;

      xkbOptions = "compose:ralt";

      windowManager.dwm.enable = true;
      displayManager.lightdm = {
        enable = true;
        background = "${pkgs.public-assets}/wallpaper_neon_3.png";
        greeters.gtk = {
          enable = true;
          theme = {
            name = "Nordic";
            package = pkgs.nordic;
          };
        };
      };
    };
    picom = {
      enable = true;
      backend = "glx";
      opacityRules = [
        "90:class_g = 'URxvt' && focused"
        "60:class_g = 'URxvt' && !focused"
      ];
    };
  };
}
