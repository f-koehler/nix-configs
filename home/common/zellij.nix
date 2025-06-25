{ config, ... }:
{
  stylix.targets.zellij.enable = config.programs.zellij.enable;
  programs.zellij.enable = false;
}
