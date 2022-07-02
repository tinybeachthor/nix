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
    flake-utils.lib.eachDefaultSystem (system: rec {
    });
}
