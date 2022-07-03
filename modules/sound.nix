{ config, lib, pkgs, ... }:
{
  sound.enable = true;
  sound.mediaKeys.enable = true;

  boot.kernelModules = [ "snd-seq" "snd-rawmidi" ];

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudio.override {
      jackaudioSupport = true;
    };
  };
  systemd.user.services.pulseaudio = {
    enable = true;
    environment = {
      JACK_PROMISCUOUS_SERVER = "jackaudio";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      jack2Full
      jack_capture
      qjackctl
    ];
  };

  services.headphones.enable = true;
}
