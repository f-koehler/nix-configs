{
  pkgs,
  config,
  ...
}:
{
  stylix.targets.rofi.enable = config.programs.rofi.enable;
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
    };
  };
}
