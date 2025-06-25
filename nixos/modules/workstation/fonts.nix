{ pkgs, ... }:
{
  stylix.targets = {
    font-packages.enable = true;
    fontconfig.enable = true;
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-sans-pro
      ubuntu-sans
    ];
  };
}
