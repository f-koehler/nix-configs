_: {
  homebrew = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    brews = [
    ];
    casks = [
      "nextcloud"
      "telegram"
    ];
    global.autoUpdate = false;
    masApps = {
      "Infuse" = 1136220934;
    };
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };
}
