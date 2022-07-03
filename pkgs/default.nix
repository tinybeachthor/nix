{ pkgs, ... }:

with pkgs;
{
  fde-setup = callPackage ./fde-setup {
    modulesPath = pkgs.path + /nixos/modules;
  };
  yubi-setup = callPackage ./yubi-setup {
    modulesPath = pkgs.path + /nixos/modules;
  };

  vim-racket = callPackage ./vim-racket {
    inherit (vimUtils) buildVimPluginFrom2Nix;
  };
  vim-mdx-js = callPackage ./vim-mdx-js {
    inherit (vimUtils) buildVimPluginFrom2Nix;
  };
}
