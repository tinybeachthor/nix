{ config, lib }:

let
  dockerBlock = {
    block = "docker";
    interval = 5;
    format = "{running}/{total}/{images}";
  };

  diskBlock = if config.networking.hostName == "ALBATROSS" then [
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
  ]
  else [
    {
      block = "disk_space";
      path = "/";
      format = "/ {available}";
      interval = 60;
    }
  ];

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
        max_width = if config.hardware.video.hidpi.enable then 64 else 32;
        buttons = ["prev" "play" "next"];
        hide_when_empty = true;
      }
    ] ++
    (lib.optional config.virtualisation.docker.enable dockerBlock) ++
    diskBlock ++
    [
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
        block = "networkmanager";
        on_click = "alacritty -e nmtui";
        ap_format = "{ssid^10} {strength}";
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
