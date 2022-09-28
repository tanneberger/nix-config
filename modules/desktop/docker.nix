{ pkgs, config, lib, ... }: {
  virtualisation.docker.enable = true;
  users.users.revol-xut.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [ docker-compose ];
} 
