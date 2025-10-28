{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      gvfs
      xfce.thunar
      xfce.thunar-volman
      vistafonts
      corefonts
    ];
  };
}
