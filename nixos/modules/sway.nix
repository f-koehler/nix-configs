{pkgs, ...}: {
  programs.sway.enable = true;
  programs.waybar.enable = true;
  hardware.opengl.enable = true;
  environment.systemPackages = [
    pkgs.rofi-wayland
    pkgs.swaynotificationcenter
  ];
}
