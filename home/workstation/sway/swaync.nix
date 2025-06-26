{ config, ... }:
{
  stylix.targets.swaync.enable = config.services.swaync.enable;
  services.swaync = {
    enable = false;
  };
}
