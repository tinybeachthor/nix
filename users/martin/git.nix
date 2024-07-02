{ pkgs, ... }:

{
  enable = true;
  lfs.enable = true;
  package = pkgs.gitFull;

  userName = "Martin Toman";
  userEmail = "25009432+tinybeachthor@users.noreply.github.com";
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
