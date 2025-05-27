{
  description = "revol-xut's NixOS and Home Mananger configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bahnbingo = {
      url = "github:tanneberger/bahn.bingo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    poettering = {
      url = "github:23x/poetti-soundsystem";
      flake = false;
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    website = {
      url = "github:tanneberger/website";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lf = {
      url = "github:icyphy/satellite-attitude-control";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nvim = {
      url = "github:NuschtOS/nvim.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.home-manager-stable.follows = "home-manager";
      inputs.nixvim.follows = "nixvim";
      inputs.nixvim-stable.follows = "nixvim";
    };
    shikane = {
      url = "gitlab:w0lff/shikane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, sops-nix, nixos-hardware, fenix, c3d2-user-module, bahnbingo, poettering, microvm, website, lf, nvim, shikane, ... }@inputs:
    let
      buildSystem = nixpkgs.lib.nixosSystem;
    in
    {
      packages."aarch64-linux".einstein = self.nixosConfigurations.einstein.config.system.build.sdImage;
      #packages."x86_64-linux".schroedinger = self.nixosConfigurations.schroedinger.config.system.build.vm;

      nixosConfigurations = {
        bothe = buildSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            nixos-hardware.nixosModules.framework-13-7040-amd
            c3d2-user-module.nixosModule
            #shikane.nixosModule
            ./hosts/bothe/configuration.nix
            ./hosts/bothe/network.nix
            ./modules/desktop/wayland.nix
            #./modules/desktop/gnome.nix
            ./modules/desktop/gnupg.nix
            ./modules/desktop/base.nix
            ./modules/server/sops.nix
            {
              nixpkgs.overlays = [
                fenix.overlays.default
              ];

              c3d2.audioStreaming = true;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit system inputs; };
              home-manager.users.tanneberger = {
                imports = [
                  nvim.homeManagerModules.nvim
                  ./modules/desktop/home.nix
                  ./modules/desktop/neomutt.nix
                ];
              };
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
            ./modules/server/bahnbingo.nix
            ./modules/server/poettering.nix
            ./modules/server/website.nix
            ./modules/server/lf.nix
            ./modules/server/lasr-web.nix
            sops-nix.nixosModules.sops
            bahnbingo.nixosModules.default
            microvm.nixosModules.host
            lf.nixosModules.default
            {
              nixpkgs.overlays = [
                bahnbingo.overlays.default
                (_final: _prev: {
                  poettering = poettering;
                })
                website.overlays.default
                lf.overlays.default
              ];
              microvm.autostart = [
                "nextcloud-vm"
              ];
            }
          ];
        };
      };
    };
}
