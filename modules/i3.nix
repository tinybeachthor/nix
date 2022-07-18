{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    enableCtrlAltBackspace = true;

    layout = config.console.keyMap;          # Use same keyMap as console
    xkbOptions = "eurosign:e, ctrl:nocaps";  # CapsLock is Ctrl

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
    synaptics.enable = false;

    # Desktop
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
    displayManager.defaultSession = "none+i3";
  };

  services.upower.enable = true;  # i3status-rust battery stats

  environment.systemPackages = with pkgs; [
    xorg.xhost  # manage access to x sesssion (e.g. allow access from docker)
  ];
}
