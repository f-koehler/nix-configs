{ pkgs, ... }:
{
  catppuccin.rofi = {
    enable = true;
    flavor = "mocha";
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
    };
  };
}
