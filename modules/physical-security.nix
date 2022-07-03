{ config, pkgs, ... }:

{
  services = {
    # usbguard - BadUSB protection
    usbguard = {
      enable = true;
      # Non-GUI package
      package = pkgs.usbguard-nox;
    };
  };
}

