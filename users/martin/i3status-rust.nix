{ config }:

let
  dockerBlock = {
    block = "docker";
    interval = 5;
    format = "{running}/{total}/{images}";
  };

in
{
  enable = true;

  bars.options = {
    icons = "awesome";

    settings = {
      theme = {
        name = "modern";
        overrides = {
          separator = "   ";
          separator_fg = "#222D32";
          separator_bg = "#222D32";
        };
      };
    };

    blocks = [
      {
        block = "music";
        player = "spotify";
        marquee = false;
        smart_trim = true;
        max_width = 32;
        buttons = ["prev" "play" "next"];
        hide_when_empty = true;
      }
    ] ++
    (if config.virtualisation.docker.enable then [dockerBlock] else []) ++
    [
      {
        block = "disk_space";
        path = "/nix";
        format = "N {available}";
        interval = 60;
      }
      {
        block = "disk_space";
        path = "/";
        format = "/ {available}";
        interval = 60;
      }
      {
        block = "memory";
        display_type = "memory";
        format_mem = "{mem_total_used_percents}";
        format_swap = "{swap_used_percents}";
      }
      {
        block = "cpu";
        interval = 1;
        format = "{utilization} {frequency}";
        info = 50;
        warning = 70;
        critical = 90;
      }
      {
        block = "net";
        device = "wlp2s0";
        interval = 5;
        format = "{signal_strength} {ssid} {ip}";
      }
      {
        block = "sound";
        driver = "pulseaudio";
      }
      {
        block = "battery";
        driver = "upower";
        format = "{percentage} {time}";
      }
      {
        block = "time";
        interval = 60;
        format = "%a %d/%m %R";
      }
    ];
  };
}
