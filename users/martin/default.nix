{ config
, lib
, pkgs
, ...
}:

let
  lock = pkgs.writeShellScriptBin "lock.sh" (builtins.readFile ./lock.sh);

in {
  xresources.properties = import ./xresources.nix;
  xsession.windowManager.i3 = import ./i3.nix { inherit pkgs; };
  xdg.configFile."i3/lock.sh".source = "${lock}/bin/lock.sh";

  services = {
    udiskie = {
      enable = true;
      automount = true;
      notify = false;
    };
    network-manager-applet = {
      enable = true;
    };
  };

  programs = {
    ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          identityFile = "/home/martin/.ssh/github@${config.networking.hostName}";
          identitiesOnly = true;
        };
      };
    };

    i3status-rust = import ./i3status-rust.nix { inherit config lib; };

    neovim = import ./neovim.nix { inherit pkgs; };
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        rust-lang.rust-analyzer
      ];
    };
    git = import ./git.nix { inherit pkgs; };
    alacritty = import ./alacritty.nix { inherit config pkgs; };
    powerline-go = {
      enable = true;
      settings = {
        numeric-exit-codes = true;
        shell = "zsh";
        mode = "flat";
        cwd-mode = "plain";
      };
      modules = [
        "cwd" "git" "jobs" "exit" "nix-shell"
        "venv" "node" "terraform-workspace"
      ];
    };
    zsh = import ./zsh.nix { inherit pkgs; };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
    };
  };

  home.packages = with pkgs; [
    fd
    pass

    gitAndTools.hub
    gitAndTools.git-absorb
    gitAndTools.git-gone
    go-task

    firefox
    chromium

    xfce.thunar
    gvfs
    webp-pixbuf-loader
    poppler
    nufraw-thumbnailer
    f3d
    freetype
    libgsf
    xfce.ristretto

    libreoffice
    pdftk
    xournal
    vlc
    shotwell
    zoom-us
    blender
    simplescreenrecorder
  ];

  home.stateVersion = "20.09";
}
