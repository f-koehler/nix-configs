{ config, ... }:
{
  programs.zellij.enable = true;
  stylix.targets.zellij.enable = config.programs.zellij.enable;
}
