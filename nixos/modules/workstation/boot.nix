{ config, ... }:
{
  boot = {
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
    };
  };
  stylix.targets = {
    grub = {
      inherit (config.boot.loader.grub) enable;
    };
    plymouth = {
      inherit (config.boot.plymouth) enable;
      logoAnimated = false;
    };
  };
}
