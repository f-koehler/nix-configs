_: {
  homebrew = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    brews = [
    ];
    casks = [
      "microsoft-teams"
      "nextcloud"
      "obsidian"
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

  nix-homebrew = {
    enable = true;
  };
}
