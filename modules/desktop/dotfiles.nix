{ pkgs, ... }: with pkgs;{
  home.file.".calcurse/caldav/config".source = ../../dotfiles/calcurse/caldav;
}
