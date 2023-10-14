_: {
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    terminal = "screen-256color";
  };
}
