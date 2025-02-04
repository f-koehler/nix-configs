{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      chromium
      distrobox
      firefox
      gvfs
      jellyfin-media-player
      kate
      protonmail-bridge
      vscode
      xfce.thunar
      xfce.thunar-volman
      exiftool
      vistafonts
      corefonts
    ];
  };
}
