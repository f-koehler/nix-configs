{ pkgs, ... }:
let
  themeFonts = {
    emoji = "Noto Color Emoji";
    monospace = "Cascadia Code NF";
    sansSerif = "Noto Sans";
    serif = "Noto Serif";
  };
in
{
  catppuccin =
    let
      accent = "mauve";
      flavor = "mocha";
    in
    {
      enable = true;
      inherit accent flavor;
      cursors = {
        enable = true;
        inherit accent flavor;
      };
      thunderbird.profile = "default";
    };
  fonts.fontconfig.defaultFonts = {
    emoji = [ themeFonts.emoji ];
    monospace = [ themeFonts.monospace ];
    sansSerif = [ themeFonts.sansSerif ];
    serif = [ themeFonts.serif ];
  };
  gtk = {
    enable = true;
    font.name = themeFonts.sansSerif;
  };
  home.packages = [
    pkgs.cascadia-code
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
  ];
  programs = {
    alacritty.settings.font = {
      normal = {
        family = themeFonts.monospace;
        style = "Regular";
      };
      bold = {
        family = themeFonts.monospace;
        style = "Bold";
      };
      italic = {
        family = themeFonts.monospace;
        style = "Italic";
      };
    };
    zed-editor.userSettings = {
      buffer_font_family = themeFonts.monospace;
      terminal.font_family = themeFonts.monospace;
      ui_font_family = themeFonts.sansSerif;
    };
  };
}
