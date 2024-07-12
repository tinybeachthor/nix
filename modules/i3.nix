{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;

      xkb = {
        layout = config.console.keyMap;          # Use same keyMap as console
        options = "eurosign:e, ctrl:nocaps";  # CapsLock is Ctrl
      };

      # use libinput instead
      synaptics.enable = false;

      # desktop
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          rofi
          i3status-rust
          i3lock-color

          xss-lock        # x sesssion locker
          xclip           # x clipboards
          maim            # screenshots
          ffmpeg          # screen-recording
          conky           # i3status-rust cpu stats
          iw              # i3status-rust wireless strength
        ];
        package = pkgs.i3-gaps;
      };
    };

    displayManager.defaultSession = "none+i3";

    # Enable touchpad support.
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        disableWhileTyping = true;
        tapping = true;
        clickMethod = "clickfinger";
      };
    };

    # i3status-rust battery stats
    upower.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xorg.xhost  # manage access to x sesssion (e.g. allow access from docker)
  ];
}
