{
  pkgs,
  config,
  nodeConfig,
  ...
}:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "${builtins.elemAt config.fonts.fontconfig.defaultFonts.sansSerif 0} ${toString nodeConfig.fontSize}";
    extraConfig = {
      show-icons = true;
    };
  };
}
