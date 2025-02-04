{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      chromium
      firefox
      gvfs
      xfce.thunar
      xfce.thunar-volman
      vistafonts
      corefonts
    ];
  };
}
