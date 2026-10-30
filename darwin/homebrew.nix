{ lib, hasTag, ... }: {
  homebrew = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    casks = [
      "deskflow"
      "nextcloud"
      "obsidian"
      "zotero"
    ]
    ++ lib.optional (hasTag "speqtral") "microsoft-teams"
    ++ lib.optional (hasTag "personal") "telegram";
    global.autoUpdate = false;
    masApps = lib.optionalAttrs (hasTag "personal") {
      "Infuse" = 1136220934;
    };
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };
}
