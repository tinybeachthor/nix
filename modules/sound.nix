{ config, lib, pkgs, ... }:
{
  boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];

  services.headphones.enable = true;
}
