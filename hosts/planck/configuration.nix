{ ... }: {
  #TODO:

  networking.hostName = "planck";
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  imports = [
    ./planck-hardware.nix
    ./network.nix
  ];

  sops.defaultSopsFile = ../../secrets/planck.yaml;
  system.stateVersion = "22.11";
}
