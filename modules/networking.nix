{ config, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };
}
