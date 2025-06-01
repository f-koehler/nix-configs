{ nodeConfig, config, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = nodeConfig.fontSizeMonospace;
        normal = {
          family = builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
          style = "Regular";
        };
        bold = {
          family = builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
          style = "Bold";
        };
        italic = {
          family = builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
          style = "Italic";
        };
        bold_italic = {
          family = builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
          style = "Bold Italic";
        };
      };
    };
  };
}
