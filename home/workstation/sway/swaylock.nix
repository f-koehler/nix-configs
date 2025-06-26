{ config, ... }:
{
  stylix.targets.swaylock.enable = config.programs.swaylock.enable;
  programs.swaylock = {
    enable = true;
  };
}
