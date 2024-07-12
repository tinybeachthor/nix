{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:rycee/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, home-manager }: {
    overlays.default = final: prev: (import ./pkgs {
      pkgs = prev;
    });

    nixosConfigurations =
      let
        nixpkgsWithOverlays = system: flakes: {
          nixpkgs = {
            config = {
              allowUnfree = true;
              allowBroken = false;
            };
            overlays = map (flake: flake.overlays.default) flakes;
          };
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

            home-manager.nixosModules.home-manager
            ./users
            ({
              networking.hostName = "ALBATROSS";
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
            # ./modules/crosscompile-aarch64-linux.nix
            ./modules/docker-rootless.nix
            # ./modules/virtual-box.nix

            home-manager.nixosModules.home-manager
            ./users
            ({
              networking.hostName = "PELICAN";
            })
          ];
        };
      };

    templates = rec {
      shell = {
        path = ./templates/shell;
        description = "Minimal dev shell flake.";
      };
      jupyter-python = {
        path = ./templates/jupyter-python;
        description = "Jupyter notebook for python.";
      };
      default = shell;
    };
  };
}
