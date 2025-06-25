{ pkgs, config, ... }:
{
  stylix = {
    autoEnable = false;
    enable = true;
    image = config.lib.stylix.pixel "base0A";
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts = {
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      monospace = {
        name = "Cascadia Code NF";
        package = pkgs.cascadia-code;
      };
      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };
      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };
    };
  };
}
