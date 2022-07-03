{ pkgs, ... }:

{
  enable = true;
  package = pkgs.i3-gaps;

  config = rec {
    modifier = "Mod4";  # Windows/Command key
    floating = {
      inherit modifier;
      border = 1;
    };
    window = {
      border = 0;
      hideEdgeBorders = "both";
      titlebar = true;
    };
    fonts = {
      names = [ "pango:DejaVu Sans Mono" "FontAwesome" ];
      style = "Bold Semi-Condensed";
      size = 11.0;
    };
    colors = {
      background = "#000000";
    };
    bars = [{
      position = "top";
      inherit fonts;
      colors = {
        separator = "#666666";
        background = "#222222";
        statusline = "#dddddd";
      };
      statusCommand = "i3status-rs ~/.config/i3status-rust/config-options.toml";
    }];

    workspaceLayout = "tabbed";
    workspaceAutoBackAndForth = true;

    keybindings = {
      "${modifier}+Shift+z" = "exec ~/.config/i3/lock.sh";

      "${modifier}+space" = "exec alacritty";

      "${modifier}+d" = "exec --no-startup-id rofi -show run";
      "${modifier}+x" = "exec --no-startup-id rofi -show window";

      "XF86AudioRaiseVolume" =
        "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% && $refresh_i3status";
      "XF86AudioLowerVolume" =
        "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% && $refresh_i3status";
      "XF86AudioMute" =
        "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
      "XF86AudioMicMute" =
        "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";

      "${modifier}+q" = "layout stacking";
      "${modifier}+w" = "layout tabbed";
      "${modifier}+e" = "layout toggle split";
      "${modifier}+v" = "split h";
      "${modifier}+s" = "split v";
      "${modifier}+f" = "fullscreen toggle";
      "${modifier}+Return" = "focus mode_toggle";
      "${modifier}+Shift+Return" = "floating toggle";

      "${modifier}+a" = "focus parent";
      "${modifier}+z" = "focus child";
      "${modifier}+h" = "focus left";
      "${modifier}+j" = "focus down";
      "${modifier}+k" = "focus up";
      "${modifier}+l" = "focus right";

      "${modifier}+Shift+q" = "kill";
      "${modifier}+Shift+h" = "move left";
      "${modifier}+Shift+j" = "move down";
      "${modifier}+Shift+k" = "move up";
      "${modifier}+Shift+l" = "move right";

      "${modifier}+grave" = "scratchpad show";
      "${modifier}+Shift+grave" = "move scratchpad";

      "${modifier}+1" = "workspace number 1";
      "${modifier}+2" = "workspace number 2";
      "${modifier}+3" = "workspace number 3";
      "${modifier}+4" = "workspace number 4";
      "${modifier}+5" = "workspace number 5";
      "${modifier}+6" = "workspace number 6";
      "${modifier}+7" = "workspace number 7";
      "${modifier}+8" = "workspace number 8";
      "${modifier}+9" = "workspace number 9";
      "${modifier}+0" = "workspace number 10";
      "${modifier}+Shift+1" = "move container to workspace number 1";
      "${modifier}+Shift+2" = "move container to workspace number 2";
      "${modifier}+Shift+3" = "move container to workspace number 3";
      "${modifier}+Shift+4" = "move container to workspace number 4";
      "${modifier}+Shift+5" = "move container to workspace number 5";
      "${modifier}+Shift+6" = "move container to workspace number 6";
      "${modifier}+Shift+7" = "move container to workspace number 7";
      "${modifier}+Shift+8" = "move container to workspace number 8";
      "${modifier}+Shift+9" = "move container to workspace number 9";
      "${modifier}+Shift+0" = "move container to workspace number 10";

      "${modifier}+Shift+c" = "reload";
      "${modifier}+Shift+r" = "restart";
      "${modifier}+Shift+e" =
        "exec i3-nagbar -t warning -m 'Exit i3 & X?' -b 'Yes' 'i3-msg exit'";

      "${modifier}+Print" = "exec --no-startup-id maim -s /tmp/latest-screenshot.png";

      "${modifier}+r" = "mode resize";
      "${modifier}+o" = "mode $launcher";
    };
    modes = {
      resize = {
        "h" = "resize shrink width 10 px or 10 ppt";
        "j" = "resize shrink height 10 px or 10 ppt";
        "k" = "resize grow height 10 px or 10 ppt";
        "l" = "resize grow width 10 px or 10 ppt";

        "r" = "mode default";
        "${modifier}+r" = "mode default";
        "Return" = "mode default";
        "Escape" = "mode default";
      };
      "$launcher" = {
        "space" = "exec alacritty; mode default";
        "f" = "exec firefox; mode default";
        "s" = "exec spotify; mode default";
        "t" = "exec thunar; mode default";
        "c" = "exec chromium; mode default";

        "Return" = "mode default";
        "Escape" = "mode default";
      };
    };
  };
  extraConfig = ''
    set $launcher Open: \
    [F]irefox [S]potify [T]hunar [C]hromium

    set $refresh_i3status killall -SIGUSR1 i3status

    exec --no-startup-id xsetroot -solid "#000000"

    # Start autolocker service
    exec --no-startup-id xss-lock --transfer-sleep-lock -l -- ~/.config/i3/lock.sh
  '';
}
