{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ ];
      });

    in {
      devShell = forAllSystems (system: let
        pkgs = nixpkgsFor.${system};
      in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            git
          ];
        }
      );
    };
}
