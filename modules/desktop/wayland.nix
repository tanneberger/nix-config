{ pkgs, config, lib, ... }: {
  programs = {
    xwayland.enable = true;
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        swaylock-fancy
        swayidle
        wl-clipboard
        mako
        alacritty
        wofi
        wofi-emoji
        #grim
        #slurp
        gnome.adwaita-icon-theme
        i3status-rust
        #dunst
        #wezterm
        swayr
        dmenu-wayland
        #waybar
      ];
    };
  };

  services.xserver.xkbOptions = "compose:ralt";
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  services.xserver.displayManager.defaultSession = "sway";
  /*input type:keyboard {
    xkb_layout "us,de,ru"
    xkb_variant ,nodeadkeys
    xkb_options grp:win_space_toggle
    repeat_delay 250
    repeat_rate 30
    }*/
}
