{ config, ... }:
{
  stylix.targets.yazi.enable = config.programs.yazi.enable;
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
