{
  description = "revol-xut's NixOS and Home Mananger configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    barrel = {
      url = "github:revol-xut/barrel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    simple-nixos-mailserver.url = gitlab:simple-nixos-mailserver/nixos-mailserver;
  };
  outputs = { self, nixpkgs, home-manager, barrel, sops-nix, nixos-hardware, simple-nixos-mailserver, ... }@inputs:
    let
      buildSystem = nixpkgs.lib.nixosSystem;
    in
    {
      packages."x86_64-linux".default = self.packages."aarch64-linux".einstein;
      packages."aarch64-linux".einstein = self.nixosConfigurations.einstein.config.system.build.sdImage;
      packages."x86_64-linux".schroedinger = self.nixosConfigurations.schroedinger.config.system.build.vm;

      nixosConfigurations = {
        kirchhoff = buildSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
            ./hosts/kirchhoff/configuration.nix
            ./hosts/kirchhoff/network.nix
            ./modules/desktop/base.nix
            ./modules/server/sops.nix
            ./modules/desktop/tu-vpn.nix
            {

              nixpkgs.overlays = [
                barrel.overlay."x86_64-linux"
              ];

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit system inputs; };
              home-manager.users.revol-xut = {
                imports = [
                  "${home-manager}/modules/accounts/email.nix"
                  ./modules/desktop/home.nix
                  ./modules/desktop/neomutt.nix
                ];
              };
            }
          ];
        };
        heisenberg = buildSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/heisenberg/configuration.nix
            ./hosts/heisenberg/network.nix
            ./modules/desktop/base.nix
            ./modules/server/sops.nix
            sops-nix.nixosModules.sops
            {

              nixpkgs.overlays = [
                barrel.overlay."x86_64-linux"
              ];

              home-manager.users.revol-xut = { pkgs, config, ... }: {
                imports = [ ./modules/desktop/home.nix ];
              };
            }
          ];
        };
        planck = buildSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            ./hosts/planck/configuration.nix
            ./modules/desktop/base.nix
            ./modules/server/sops.nix
            {
              home-manager.users.revol-xut = { pkgs, config, ... }: {
                imports = [ ./modules/desktop/home.nix ];
              };
            }
          ];
        };
        einstein = buildSystem {
          system = "aarch64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            ./hosts/einstein/configuration.nix
            ./modules/server/base.nix
            ./modules/server/audio-server.nix
            #./modules/server/clock.nix

            sops-nix.nixosModules.sops
            {
              nixpkgs.config.allowBroken = true;
              sdImage.compressImage = false;
            }
          ];
        };
        schroedinger = buildSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/schroedinger/configuration.nix
            ./modules/server/base.nix
            ./modules/server/nextcloud.nix
            ./modules/server/gitea.nix
            ./modules/server/rmfakecloud.nix
            simple-nixos-mailserver.nixosModule
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
