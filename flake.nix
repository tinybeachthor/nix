{
  inputs = {
    flake-utils.url = github:numtide/flake-utils/master;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    home-manager = {
      url = github:rycee/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-db = {
      url = "github:usertam/nix-index-db/standalone/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, flake-utils, nixpkgs, home-manager, nix-index-db }:
    flake-utils.lib.eachDefaultSystem (system: {
      overlay = final: prev: (import ./pkgs {
        pkgs = prev;
      });
      packages = (import nixpkgs {
        inherit system;
        overlays = [
          self.overlay.${system}
        ];
      });
    })
    //
    {
      nixosConfigurations =
        let
          nixpkgsWithOverlays = system: flakes: {
            nixpkgs = {
              config = {
                allowUnfree = true;
                allowBroken = false;
              };
              overlays = map (flake: flake.overlay.${system}) flakes;
            };
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.pkgs.flake = self;
          };
        in {
          ALBATROSS = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              (nixpkgsWithOverlays system [ self ])
              ./cachix.nix
              ./hardware/lenovo-l380-yoga.nix

              ./modules/nix.nix
              ./modules/powersave.nix
              ./modules/hibernate.nix
              ./modules/i3.nix
              ./modules/brightness.nix
              ./modules/sound.nix
              ./modules/fonts.nix
              ./modules/env.nix
              ./modules/docker.nix

              home-manager.nixosModules.home-manager
              (import ./users { inherit nix-index-db system; })
              ({
                networking.hostName = "ALBATROSS";
                time.timeZone       = "America/Los_Angeles";
              })
            ];
          };
          PELICAN = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              (nixpkgsWithOverlays system [ self ])
              ./cachix.nix
              ./hardware/framework.nix

              ./modules/nix.nix
              ./modules/powersave.nix
              ./modules/hibernate.nix
              ./modules/i3.nix
              ./modules/brightness.nix
              ./modules/sound.nix
              ./modules/fonts.nix
              ./modules/env.nix

              home-manager.nixosModules.home-manager
              (import ./users { inherit nix-index-db system; })
              ({
                networking.hostName = "PELICAN";
                time.timeZone       = "America/Los_Angeles";
              })
            ];
          };
        };
    };
}
