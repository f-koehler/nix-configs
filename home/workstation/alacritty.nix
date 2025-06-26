{ config, ... }:
{
  programs.alacritty.enable = true;
  stylix.targets.alacritty.enable = config.programs.alacritty.enable;
}
