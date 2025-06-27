{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      chromium
      gvfs
      xfce.thunar
      xfce.thunar-volman
      vistafonts
      corefonts
    ];
  };
  stylix.targets.chromium.enable = true;
}
