{ config, pkgs, ... }:

let
  settings = {
    general = {
      live_config_reload = false;
    };
    env = { TERM = "xterm-256color"; };
    window = {
      dimensions = {
        columns = 0;
        lines = 0;
      };
      padding = {
        x = 0;
        y = 0;
      };
      opacity = 1;
      dynamic_padding = false;
      decorations = "full";
      startup_mode = "Windowed";
      dynamic_title = true;
    };
    scrolling = {
      history = 50000;
      multiplier = 3;
    };

    font = {
      normal = {
        family = "Hack";
        style = "Regular";
      };
      bold = {
        family = "Hack";
        style = "Bold";
      };
      size = 15;
      offset = {
        x = 0;
        y = 0;
      };
      glyph_offset = {
        x = 0;
        y = 0;
      };
    };
    colors = {
      primary = {
        background = "0x181818";
        foreground = "0xf4f4f4";
      };
      normal = {
        black = "0x263640";
        red = "0xd12f2c";
        green = "0x819400";
        yellow = "0xb08500";
        magenta = "0x2587cc";
        blue = "0x696ebf";
        cyan = "0x289c93";
        white = "0xbfbaac";
      };
      bright = {
        black = "0x4a697d";
        red = "0xfa3935";
        green = "0xa4bd00";
        yellow = "0xd9a400";
        magenta = "0x8086e8";
        blue = "0x2ca2f5";
        cyan = "0x33c5ba";
        white = "0xfdf6e3";
      };
      indexed_colors = [ ];
      draw_bold_text_with_bright_colors = true;
    };
    bell = {
      duration = 0;
      animation = "EaseOutExpo";
      color = "0xffffff";
    };
    mouse = {
      hide_when_typing = true;
      bindings = [{
        mouse = "Middle";
        action = "PasteSelection";
      }];
    };
    selection = {
      semantic_escape_chars = '';│`|:"' ()[]{}<>'';
      save_to_clipboard = true;
    };
    cursor = {
      style = "Block";
      unfocused_hollow = true;
    };
    working_directory = "None";
    debug = {
      render_timer = false;
      persistent_logging = false;
      log_level = "Warn";
      print_events = false;
    };

    keyboard.bindings = [
      { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
      { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }

      { key = "L"; mods = "Control"; action = "ClearLogNotice"; }
    ];
  };

  package = pkgs.runCommand "alacritty" {
    buildInputs = with pkgs; [ makeWrapper ];
  } ''
    mkdir $out
    # Link every top-level dir to our new target
    ln -s ${pkgs.alacritty}/* $out
    # Except the bin dir
    rm $out/bin
    mkdir $out/bin
    # We create the bin dir ourselves and link every binary in it
    ln -s ${pkgs.alacritty}/bin/* $out/bin
    # Except the program binary
    rm $out/bin/alacritty
    # Because we create this ourself, by creating a wrapper
    makeWrapper ${pkgs.alacritty}/bin/alacritty $out/bin/alacritty \
      --set "WINIT_HIDPI_FACTOR" "1" \
      --set "WINIT_X11_SCALE_FACTOR" "1"
  '';

in

{
  enable = true;
  inherit package settings;
}
