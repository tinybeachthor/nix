{ pkgs, ... }:

{
  enable = true;
  enableCompletion = true;
  enableAutosuggestions = true;

  defaultKeymap = "emacs";

  autocd = true;

  history = {
    size = 100000;
    path = ".histfile";
    ignoreDups = true;
    expireDuplicatesFirst = true;
    share = true;
    extended = true;
  };

  initExtra = ''
    setopt NOTIFY

    # <C-W> delete word or path component
    my-backward-delete-word() {
      local WORDCHARS=$\{WORDCHARS/\//}
      zle backward-delete-word
    }
    zle -N my-backward-delete-word
    bindkey '^W' my-backward-delete-word

    export EXA_COLORS="\
    da=38;5;240:uu=38;5;250:\
    *.nix=38;5;228:*.md=31;1:\
    "

    # powerline-go
  '';

  shellAliases = import ./aliases.nix;
}
