_:
let
  themeFonts = {
    emoji = "Noto Color Emoji";
    monospace = "Cascadia Code NF";
    sansSerif = "Noto Sans";
    serif = "Noto Serif";
  };
in
{
  catppuccin = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };
  fonts.fontconfig.defaultFonts = {
    emoji = [ themeFonts.emoji ];
    monospace = [ themeFonts.monoSpace ];
    sansSerif = [ themeFonts.sansSerif ];
    serif = [ themeFonts.serif ];
  };
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
  };
}
