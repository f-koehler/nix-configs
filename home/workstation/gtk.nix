{
  config,
  pkgs,
  nodeConfig,
  ...
}:
{
  gtk.font = {
    package = pkgs.noto-fonts;
    name = builtins.elemAt config.fonts.fontconfig.defaultFonts.sansSerif 0;
    size = nodeConfig.fontSize;
    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze-dark";
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
