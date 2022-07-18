{ config, pkgs, ... }:

{
  nix.trustedUsers = [ "root" "martin" ];

  security.sudo.wheelNeedsPassword = false;
  security.sudo.execWheelOnly = true;

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
      ++ (if (config.virtualisation.docker.enable == true) then ["docker"] else []);

      home = "/home/martin";
      createHome = true;

      shell = pkgs.zsh;

      isNormalUser = true;
      uid = 1000;
    };
  };
  home-manager.users = {
    martin = { pkgs, ... }:
    let
      lock = pkgs.writeShellScriptBin "lock.sh"
        (builtins.readFile ./martin/lock.sh);
    in
    {
      xresources.properties = import ./martin/xresources.nix;

      xsession.windowManager.i3 = import ./martin/i3.nix { inherit config pkgs; };
      xdg.configFile."i3/lock.sh".source = "${lock}/bin/lock.sh";

      programs = {
        nix-index.enable = true;

        i3status-rust = import ./martin/i3status-rust.nix { inherit config; };

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
        neovim = import ./martin/neovim.nix { inherit pkgs; };
        git = import ./martin/git.nix { inherit pkgs; };
        gh = {
          enable = true;
          settings = {
            gitProtocol = "ssh";
          };
        };
        alacritty = import ./martin/alacritty.nix { inherit config pkgs; };

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
        xfce.ristretto
        spotify

        libreoffice
        pdftk
        xournal
        vlc
        rmapi
        shotwell

        zoom-us
      ];

      home.stateVersion = "20.09";
    };
  };
  home-manager.useGlobalPkgs = true;
}
