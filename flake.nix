{
  inputs = {
    flake-utils.url = github:numtide/flake-utils/master;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;
    home-manager = {
      url = github:rycee/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, home-manager }:
    flake-utils.lib.eachDefaultSystem (system: {
      nixosConfigurations =
        let
          nixpkgsWithOverlays = system: flakes: {
            nixpkgs = {
              config = {
                allowUnfree = true;
                allowBroken = false;
              };
              overlays = map (flake: (final: prev: flake.packages.${system})) flakes;
            };
            nix.registry.nixpkgs.flake = nixpkgs;
          };
        in {
          ALBATROSS = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              (nixpkgsWithOverlays system [ ])
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
              ({
                networking.hostName = "ALBATROSS";
                time.timeZone       = "America/Los_Angeles";
              })
            ];
          };
        };
    });
}
