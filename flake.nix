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

    c3d2-user-module = {
      url = "git+https://gitea.c3d2.de/C3D2/nix-user-module.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = github:NixOS/nixos-hardware/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix/monthly";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    shikane = {
      url = "gitlab:w0lff/shikane/nixification";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bahnbingo.url = "github:tanneberger/bahn.bingo";
    poettering = {
      url = "github:23x/poetti-soundsystem";
      flake = false;
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = { self, nixpkgs, home-manager, sops-nix, nixos-hardware, fenix, c3d2-user-module, shikane, bahnbingo, poettering, microvm, ... }@inputs:
    let
      buildSystem = nixpkgs.lib.nixosSystem;
    in
    {
      packages."aarch64-linux".einstein = self.nixosConfigurations.einstein.config.system.build.sdImage;
      #packages."x86_64-linux".schroedinger = self.nixosConfigurations.schroedinger.config.system.build.vm;

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
            #./modules/desktop/gnome.nix
            ./modules/desktop/gnupg.nix
            ./modules/desktop/base.nix
            ./modules/server/sops.nix
            ./modules/desktop/docker.nix
            ./modules/desktop/tu-vpn.nix
            c3d2-user-module.nixosModule
            {
              environment.systemPackages = [
                fenix.packages.x86_64-linux.stable.toolchain
              ];

              c3d2.audioStreaming = true;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit system inputs; };
              home-manager.users.revol-xut = {
                imports = [
                  #"${home-manager}/modules/accounts/email.nix"
                  ./modules/desktop/home.nix
                  ./modules/desktop/neomutt.nix
                ];
              };
            }
          ];
        };
        /*einstein = buildSystem {
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
        };*/
        /*schroedinger = buildSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/schroedinger/configuration.nix
            ./modules/server/base.nix
            ./modules/server/nextcloud.nix
            ./modules/server/bahnbingo.nix
            ./modules/server/poettering.nix
            ./modules/server/website.nix
            sops-nix.nixosModules.sops
            bahnbingo.nixosModules.default
            microvm.nixosModules.host
            {
              nixpkgs.overlays = [
                bahnbingo.overlays.default
                (final: prev: {
                  poettering = poettering;
                })
              ];
              microvm.autostart = [
                "nextcloud-vm"
              ];
            }
          ];
        };*/
        nextcloud-vm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            microvm.nixosModules.microvm
            {
              networking.hostName = "nextcloud-vm";
              microvm.hypervisor = "cloud-hypervisor";
            }
          ];
        };
      };
    };
}
