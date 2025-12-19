_: {
  home = {
    username = "fkoehler";
    homeDirectory = "/Users/fkoehler";
  };
  targets.darwin = {
    copyApps.enable = true;
    defaults = {
      "com.apple.dock" = {
      };
      "com.apple.menuextra.clock" = {
        Show24Hour = true;
        ShowAMPM = false;
        ShowDate = 1;
      };
    };
    currentHostDefaults = {
      "com.apple.controlcenter".BatteryShowPercentage = true;
    };
  };
}
