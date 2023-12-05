_: {
  programs.fish = {
    enable = true;
    shellInit = ''
      eval "$(micromamba shell hook --shell=fish)"
    '';
  };
}
