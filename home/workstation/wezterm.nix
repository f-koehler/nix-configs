{
  pkgs,
  config,
  ...
}:
{
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  stylix.targets.wezterm.enable = config.programs.wezterm.enable;
}
