_: {
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    terminal = "screen-256color";
  };
}
