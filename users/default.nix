{ system }:
{ config, pkgs, lib, ... }:

{
  nix.settings.trusted-users = [ "root" "martin" ];

  security.sudo.execWheelOnly = true;
  security.sudo.wheelNeedsPassword = false;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
    thunar-dropbox-plugin
    thunar-media-tags-plugin
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  programs.zsh.enable = true;

  # GPG
  programs.gnupg.agent.enable = true;

  # Userspace mountable disks
  services.udisks2.enable = true;

  # Location
  location.provider = "geoclue2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    martin = {
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "jackaudio"
        "video"
      ]
      ++ lib.optional (config.virtualisation.docker.enable && !config.virtualisation.docker.rootless.enable) "docker";

      home = "/home/martin";
      createHome = true;

      shell = pkgs.zsh;

      isNormalUser = true;
      uid = 1000;
    };
  };
  home-manager.users = {
    martin = { pkgs, ... }@inputs:
    let
      lock = pkgs.writeShellScriptBin "lock.sh"
        (builtins.readFile ./martin/lock.sh);
    in
    {
      xresources.properties = import ./martin/xresources.nix;
      xsession.windowManager.i3 = import ./martin/i3.nix { inherit config pkgs; };
      xdg.configFile."i3/lock.sh".source = "${lock}/bin/lock.sh";

      services = {
        udiskie = {
          enable = true;
          automount = true;
          notify = false;
        };
        network-manager-applet.enable = true;
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

        i3status-rust = import ./martin/i3status-rust.nix { inherit config lib; };

        neovim = import ./martin/neovim.nix { inherit pkgs; };
        git = import ./martin/git.nix { inherit pkgs; };
        alacritty = import ./martin/alacritty.nix { inherit config pkgs; };
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

        zsh = import ./martin/zsh.nix { inherit pkgs; };
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

        neomutt = { enable = true; vimKeys = true; };
        mbsync = { enable = true; };
        msmtp = { enable = true; };
        notmuch = {
          enable = true;
          hooks = {
            preNew = "mbsync --all";
          };
        };
      };

      accounts.email.accounts = import ./martin/email-accounts.nix { inherit pkgs; };

      home.packages = with pkgs; [
        fd  # fzf source
        pass

        gitAndTools.hub
        gitAndTools.git-absorb
        gitAndTools.git-gone

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
        spotify

        libreoffice
        pdftk
        xournal
        vlc
        rmapi
        shotwell
        zoom-us
        blender
      ];

      home.stateVersion = "20.09";
    };
  };
  home-manager.useGlobalPkgs = true;
}
