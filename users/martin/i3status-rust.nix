{ config, lib }:

let
  dockerBlock = {
    block = "docker";
    interval = 15;
    format = " $icon $running/$total ";
  };

  diskBlock = [
    {
      block = "disk_space";
      path = "/";
      format = "/ $available ";
      interval = 60;
    }
  ] ++ lib.optional (config.networking.hostName == "ALBATROSS") {
      block = "disk_space";
      path = "/nix";
      format = " N $available ";
      interval = 60;
  };

in
{
  enable = true;

  bars.options = {
    icons = "awesome4";
    theme = "modern";

    settings = {
      theme = {
        theme = "modern";
        overrides = {
          separator = "   ";
          separator_fg = "#222D32";
          separator_bg = "#222D32";
        };
      };
    };

    blocks = [
      {
        block = "cpu";
        interval = 1;
        format = " $icon $utilization $frequency ";
      }
      {
        block = "memory";
        format = " $icon $mem_used_percents.eng(w:1) ";
      }
    ] ++
    # (lib.optional config.virtualisation.docker.enable dockerBlock) ++
    diskBlock ++
    [
      {
        block = "music";
        player = "spotify";
        format = " $icon {$combo.str(max_w:32) $prev $play $next |} ";
      }
      {
        block = "sound";
        driver = "pulseaudio";
      }
      {
        block = "net";
        format = " $icon {$signal_strength $ssid|Wired} {$ip|N/A} ";
      }
      {
        block = "battery";
        driver = "upower";
        format = " $icon $percentage $time ";
      }
      {
        block = "time";
        interval = 60;
      }
    ];
  };
}
