{ lib, pkgs, ... }:
let
  defaultWallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [ "${defaultWallpaper}" ];

      wallpaper = [
        ",${defaultWallpaper}"
      ];
    };
  };
}
