{ pkgs, config, lib, ... }: {
  programs = {
    xwayland.enable = true;
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        swaylock-fancy
        swaylock
        swayidle
        wl-clipboard
        mako
        alacritty
        wofi
        wofi-emoji
        gnome.adwaita-icon-theme
        i3status-rust
        swayr
        dmenu-wayland
        xdg-desktop-portal-wlr
        swayidle
      ];
    };
  };

  services.xserver.xkbOptions = "compose:ralt";
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  services.xserver.displayManager.defaultSession = "sway";

  xdg.portal.wlr.enable = true;
  /*input type:keyboard {
    xkb_layout "us,de,ru"
    xkb_variant ,nodeadkeys
    xkb_options grp:win_space_toggle
    repeat_delay 250
    repeat_rate 30
    }*/


  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-wlr
  ];
}
