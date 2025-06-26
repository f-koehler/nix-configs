{ config, ... }:
{
  stylix.targets.starship.enable = config.programs.starship.enable;
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
