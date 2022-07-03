{ pkgs, ... }:

{
  enable = true;
  package = pkgs.gitFull;

  userName = "Martin Toman";
  userEmail = "toman.martin@live.com";
  signing = null;

  ignores = [
    "Session.vim"
    "*.un~"
    "*.swp"
    ".vim/"
    "NetrwTreeListing"

    ".direnv/"
    ".histfile"

    "tags"
    ".ccls-cache/"
  ];

  extraConfig = {
    core = { };
    init = {
      defaultBranch = "main";
    };
    rerere = { enabled = true; };

    merge = { tool = "vimdiff"; };
    diff = { tool = "vimdiff"; };
  };
}
