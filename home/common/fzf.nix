{ config, ... }:
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
  stylix.targets.fzf.enable = false;
  catppuccin.fzf.enable = config.programs.fzf.enable;
}
