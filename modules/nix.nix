{ pkgs, ... }:

{
  # Install the flakes edition
  nix.package = pkgs.nixFlakes;
  # Enable the nix command and flakes
  # Keeps for nix-direnv garbage collection
  # Garbage collect if disk full
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

  # Binary caches
  nix.binaryCachePublicKeys = [
  "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.binaryCaches = [
    "https://hydra.iohk.io"
  ];

  # Garbage collect old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # AutoOptimiseStore
  nix.autoOptimiseStore = true;
}
