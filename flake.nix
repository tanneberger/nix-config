{
  description = "revol-xut's NixOS and Home Mananger configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    c3d2-user-module.url = "git+https://gitea.c3d2.de/C3D2/nix-user-module.git";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    simple-nixos-mailserver.url = gitlab:simple-nixos-mailserver/nixos-mailserver;
    #alarm-clock.url = github:revol-xut/lf-alarm-clock;
    fenix.url = "github:nix-community/fenix/monthly";
    shikane.url = "gitlab:w0lff/shikane/nixification";
  };
  outputs = { self, nixpkgs, home-manager, sops-nix, nixos-hardware, simple-nixos-mailserver, fenix, c3d2-user-module, shikane, ... }@inputs:
    let
      buildSystem = nixpkgs.lib.nixosSystem;
    in
    {
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
            ./modules/desktop/wayland.nix
            ./modules/desktop/gnupg.nix
            ./modules/desktop/base.nix
            ./modules/server/sops.nix
            c3d2-user-module.nixosModule
            ./modules/desktop/docker.nix
            ./modules/desktop/tu-vpn.nix
            {
              
              #c3d2.audioStreaming = true;

              environment.systemPackages = [
                fenix.packages.x86_64-linux.stable.toolchain
              ];

              nixpkgs.overlays = [
                #shikane.overlay
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
            ./modules/desktop/wayland.nix
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
            ./modules/server/clock.nix
            #alarm-clock.nixosModule
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
            #./modules/server/mail.nix
            simple-nixos-mailserver.nixosModule
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
