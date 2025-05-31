{
  pkgs,
  lib,
  isLinux,
  nodeConfig,
  ...
}:
lib.mkIf isLinux
&& (builtins.elem "plasma" nodeConfig.desktops) {
  programs.plasma = lib.mkIf isLinux {
    enable = true;
    workspace = {
      clickItemTo = "select";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
    };
    kwin = {
      virtualDesktops.number = 10;
      nightLight = {
        enable = true;
        location = {
          latitude = "1.310956915456913";
          longitude = "103.79518562283889";
        };
        mode = "location";
        temperature = {
          day = 6500;
          night = 4200;
        };
      };
    };
    shortcuts = {
      kwin = {
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Desktop 5" = "Meta+5";
        "Switch to Desktop 6" = "Meta+6";
        "Switch to Desktop 7" = "Meta+7";
        "Switch to Desktop 8" = "Meta+8";
        "Switch to Desktop 9" = "Meta+9";
        "Switch to Desktop 10" = "Meta+0";
        "Window to Desktop 1" = "Meta+Shift+1";
        "Window to Desktop 2" = "Meta+Shift+2";
        "Window to Desktop 3" = "Meta+Shift+3";
        "Window to Desktop 4" = "Meta+Shift+4";
        "Window to Desktop 5" = "Meta+Shift+5";
        "Window to Desktop 6" = "Meta+Shift+6";
        "Window to Desktop 7" = "Meta+Shift+7";
        "Window to Desktop 8" = "Meta+Shift+8";
        "Window to Desktop 9" = "Meta+Shift+9";
        "Window to Desktop 10" = "Meta+Shift+0";
        "Show Desktop" = "none";
      };
    };
    spectacle.shortcuts.launch = "Print";
    hotkeys.commands."launch-alacritty" = {
      name = "Launch alacritty";
      key = "Meta+Return";
      command = "alacritty";
    };
    hotkeys.commands."launch-krunner" = {
      name = "Launch krunner";
      key = "Meta+D";
      command = "krunner";
    };
    configFile = {
      baloofilerc."Basic Settings".Indexing-Enabled.value = false;
      kwinrc.Plugins.krohnkiteEnabled = false;
    };
    powerdevil = {
      AC = {
        autoSuspend.action = "nothing";
        dimDisplay = {
          enable = true;
          idleTimeout = 300;
        };

        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = true;

        turnOffDisplay = {
          idleTimeout = 600;
          idleTimeoutWhenLocked = 120;
        };
      };
      battery = {
        autoSuspend.action = "sleep";
        dimDisplay = {
          enable = true;
          idleTimeout = 120;
        };

        whenLaptopLidClosed = "sleep";
        inhibitLidActionWhenExternalMonitorConnected = true;

        turnOffDisplay = {
          idleTimeout = 300;
          idleTimeoutWhenLocked = 60;
        };
      };
      general.pausePlayersOnSuspend = true;
    };
  };
}
