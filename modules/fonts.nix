{ config, pkgs, lib, ... }:

{
  fonts = {
    fontconfig.enable = lib.mkDefault true;
    fontDir.enable = config.fonts.fontconfig.enable;
    enableGhostscriptFonts = config.fonts.fontconfig.enable;

    fonts = lib.mkIf config.fonts.fontconfig.enable (with pkgs; [
      corefonts
      terminus_font
      corefonts           # Microsoft free fonts
      inconsolata         # monospaced
      ubuntu_font_family  # Ubuntu fonts
      unifont             # some international languages
      hack-font
      noto-fonts
      powerline-fonts
      font-awesome
      font-awesome_4  # i3status-rust icon font
    ]);
  };
}
