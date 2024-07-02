{ pkgs, config, lib, ... }: {
  virtualisation.docker = {
    enable = true;
    #enableOnBoot = true;
    #rootless = {
    #  enable = true;
    #};
  };
  users.users.revol-xut.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [ docker-compose ];
} 
