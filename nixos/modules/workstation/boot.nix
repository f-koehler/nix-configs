{ config, ... }:
{
  boot = {
    plymouth = {
      enable = true;
    };
  };
  stylix.targets = {
    grub = {
      inherit (config.boot.grub) enable;
      useWallpaper = true;
    };
    plymouth = {
      inherit (config.boot.plymouth) enable;
      logoAnimated = false;
    };
  };
}
