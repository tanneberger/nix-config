{ pkgs, config, lib, ... }: {
  virtualisation.docker = {
    enable = false;
    #rootless = {
    #  enable = true;
    #};
  };
  users.users.revol-xut.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [ docker-compose ];
} 
