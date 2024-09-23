{
  pkgs,
  isWorkstation,
  lib,
  isLinux,
  ...
}: {
  programs.plasma = lib.mkIf (isLinux && isWorkstation) {
    enable = true;
    workspace = {
      clickItemTo = "select";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
    };
    hotkeys.commands."launch-wezterm" = {
      name = "Launch wezterm";
      key = "Meta+Return";
      command = "wezterm";
    };
    hotkeys.commands."launch-krunner" = {
      name = "Launch krunner";
      key = "Meta+D";
      command = "krunner";
    };
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled".value = false;
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
