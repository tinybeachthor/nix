{ pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  console.font       = "Lat2-Terminus16";
  console.keyMap     = "us";

  # Add packages to environment
  environment = {
    systemPackages = with pkgs;
    let
      core-packages = [
        neovim
        ispell
        aspellDicts.en

        cloc

        cachix
        nixfmt

        htop

        archiver
        zip
        unzip

        bat
        exa
        bash
        binutils
        coreutils
        psmisc
        tldr
        lsof

        which
        file
        findutils
        ripgrep
        vifm

        wget
        curl
        iputils
        inetutils
        httpie
      ];
      backup-packages = [
        gitFull
        gitAndTools.git-annex
        gitAndTools.gitRemoteGcrypt
        rsync
        git-crypt
      ];
      crypt-packages = [
        cryptsetup
        gnupg1
        kbfs
        keybase
        keybase-gui
      ];
    in
      core-packages
      ++ backup-packages
      ++ crypt-packages;

    variables = {
      TERMINAL = "xterm";
      TERM = "xterm";

      EDITOR = "nvim";
      VISUAL = "nvim";

      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };
}
