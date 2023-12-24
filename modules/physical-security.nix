{ config, pkgs, ... }:

{
  services = {
    # usbguard - BadUSB protection
    usbguard = {
      enable = true;
      package = pkgs.usbguard;
    };
  };
}

