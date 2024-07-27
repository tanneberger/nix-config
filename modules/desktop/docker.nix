{ ... }: {
  virtualisation.docker = {
    enable = true;
    #enableOnBoot = true;
    #rootless = {
    #  enable = true;
    #};
  };

  users.users.revol-xut.extraGroups = [ "docker" ];
} 
