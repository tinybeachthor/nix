{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    pypi-deps-db = {
      url = "github:DavHau/pypi-deps-db/master";
      flake = false;
    };
    mach-nix = {
      url = "github:DavHau/mach-nix/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pypi-deps-db.follows = "pypi-deps-db";
      };
    };
  };

  outputs = { self, nixpkgs, mach-nix, ... }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ ];
      });

    in {
      devShell = forAllSystems (system: import ./shell.nix {
        pkgs = nixpkgsFor.${system};
        inherit (mach-nix.lib.${system}) mkPython;
      });
    };
}
