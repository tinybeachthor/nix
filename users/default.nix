{ config
, lib
, pkgs
, ...
}:

let
  cfgDocker = config.virtualisation.docker;
  cfgVbox = config.virtualisation.virtualbox;

in {
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
      ++ (lib.optional (cfgDocker.enable && !cfgDocker.rootless.enable) "docker")
      ++ (lib.optional (cfgVbox.host.enable) "vboxusers");

      home = "/home/martin";
      createHome = true;

      shell = pkgs.zsh;

      isNormalUser = true;
      uid = 1000;
    };
  };
  home-manager.users = {
    martin = { pkgs, ... }: (import ./martin {
      inherit config lib;
      inherit pkgs;
    });
  };

  home-manager.useGlobalPkgs = true;
}
