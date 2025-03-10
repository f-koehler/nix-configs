{ config, ... }:
{
  home.packages = [ config.programs.ghostty.package ];
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
