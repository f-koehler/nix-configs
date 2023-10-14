_: {
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      style = "compact";
      inline_height = 20;
      show_preview = true;
    };
    flags = [
      "--disable-up-arrow"
    ];
  };
}
