{ pkgs, config, lib, ... }: {
  virtualisation.docker.enable = false;
  users.users.revol-xut.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [ docker-compose ];
} 
