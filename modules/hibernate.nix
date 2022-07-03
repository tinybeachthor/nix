{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [
    "hibernate"
  ];

  services.logind = {
    lidSwitch = "suspend-then-hibernate";

    # Don’t shutdown when power button is short-pressed
    extraConfig = "HandlePowerKey=ignore";
  };
  environment.etc."systemd/sleep.conf".text = ''
    [Sleep]
    HibernateDelaySec=1h
  '';

  environment.systemPackages = with pkgs; [
    hibernate
  ];
}
