{ config
, pkgs
, lib
, ...
}:

{
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  isoImage.squashfsCompression = lib.mkDefault "gzip -Xcompression-level 1";

  environment = {
    systemPackages = with pkgs; [
      cryptsetup
      fde-setup
      yubi-setup
      yubikey-personalization
      openssl
      parted
      btrfs-progs

      git
      git-crypt
      wget
      neovim
    ];
  };

  system.nixos-generate-config.configuration = ''
    # Edit this configuration file to define what should be installed on
    # your system.  Help is available in the configuration.nix(5) man page
    # and in the NixOS manual (accessible by running ‘nixos-help’).

    { config, pkgs, ... }:

    {
      imports = [
        # Include the results of the hardware scan.
        ./hardware-configuration.nix

        # Include FDE setup, if you did not use `fresh-setup-fde` remove next line.
        ./fde-configuration.nix
      ];

    $bootLoaderConfig

      boot.kernelPackages = pkgs.linuxPackages_latest;

      # Define your hostname.
      networking.hostName = "nixos";
      networking.networkmanager.enable = true;
      services.avahi = {
        enable = true;
        nssmdns4 = true;
      };

    $networkingDhcpConfig

    $xserverConfig

    $desktopConfiguration

      nix.package = pkgs.nixVersions.stable;
      nix.extraOptions = \'\'
        experimental-features = nix-command flakes
      \'\';

      environment.systemPackages = with pkgs; [
        neovim
        wget
        git
        git-crypt

        parted
        btrfs-progs
        cryptsetup
        yubikey-personalization
        openssl
      ];
      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion =
        "${config.system.nixos.release}"; # Did you read the comment?
    }
  '';
}
