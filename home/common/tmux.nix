{ config, ... }:
{
  stylix.targets.tmux.enable = false;
  catppuccin.tmux = {
    inherit (config.programs.tmux) enable;
  };
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    terminal = "tmux-256color";
    extraConfig = ''
      set -sg terminal-overrides ",*:RGB"
    '';
  };
}
