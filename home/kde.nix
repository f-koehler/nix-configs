{ lib, pkgs, ... }:
{
  home.activation.rebuildKdeSycoca = lib.mkIf pkgs.stdenv.isLinux (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if command -v kbuildsycoca6 > /dev/null 2>&1; then
        $DRY_RUN_CMD kbuildsycoca6
      elif command -v kbuildsycoca5 > /dev/null 2>&1; then
        $DRY_RUN_CMD kbuildsycoca5
      fi
    ''
  );
  qt = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    kde.settings = {
      kcminputrc = {
        Mouse = {
          cursorTheme = "catppuccin-mocha-mauve-cursors";
        };
      };
      kdeglobals = {
        Icons = {
          Theme = "Papirus-Dark";
        };
        KDE = {
          AnimationDurationFactor = 0;
          LookAndFeelPackage = "Catppuccin-Mocha-Mauve";
          widgetStyle = "Breeze";
        };
        Sounds = {
          Enable = false;
        };
      };
      kglobalshortcutsrc = {
        ksmserver = {
          "Lock Session" = "Screensaver,Meta+L\tScreensaver,Lock Session";
        };
        kwin = {
          "Switch to Desktop 1" = "Meta+1,Ctrl+F1,Switch to Desktop 1";
          "Switch to Desktop 2" = "Meta+2,Ctrl+F2,Switch to Desktop 2";
          "Switch to Desktop 3" = "Meta+3,Ctrl+F3,Switch to Desktop 3";
          "Switch to Desktop 4" = "Meta+4,Ctrl+F4,Switch to Desktop 4";
          "Switch to Desktop 5" = "Meta+5,,Switch to Desktop 5";
          "Switch to Desktop 6" = "Meta+6,,Switch to Desktop 6";
          "Switch to Desktop 7" = "Meta+7,,Switch to Desktop 7";
          "Switch to Desktop 8" = "Meta+8,,Switch to Desktop 8";
          "Switch to Desktop 9" = "Meta+9,,Switch to Desktop 9";
          "Switch to Desktop 10" = "Meta+0,,Switch to Desktop 10";
          "Window to Desktop 1" = "Meta+!,,Window to Desktop 1";
          "Window to Desktop 2" = "Meta+@,,Window to Desktop 2";
          "Window to Desktop 3" = "Meta+#,,Window to Desktop 3";
          "Window to Desktop 4" = "Meta+$,,Window to Desktop 4";
          "Window to Desktop 5" = "Meta+%,,Window to Desktop 5";
          "Window to Desktop 6" = "Meta+^,,Window to Desktop 6";
          "Window to Desktop 7" = "Meta+&,,Window to Desktop 7";
          "Window to Desktop 8" = "Meta+*,,Window to Desktop 8";
          "Window to Desktop 9" = "Meta+(,,Window to Desktop 9";
          "Show Desktop" = "none,Meta+D,Peek at Desktop";
          "Window Fullscreen" = "Meta+F,,Make Window Fullscreen";
          "KrohnkiteFocusDown" = "Meta+J,none,Krohnkite: Focus Down";
          "KrohnkiteFocusLeft" = "Meta+H,none,Krohnkite: Focus Left";
          "KrohnkiteFocusNext" = "Meta+.,none,Krohnkite: Focus Next";
          "KrohnkiteFocusPrev" = "Meta+\\,,none,Krohnkite: Focus Previous";
          "KrohnkiteFocusRight" = "Meta+L,none,Krohnkite: Focus Right";
          "KrohnkiteFocusUp" = "Meta+K,none,Krohnkite: Focus Up";
          "KrohnkiteMonocleLayout" = "Meta+M,none,Krohnkite: Monocle Layout";
          "KrohnkiteSetMaster" = "Meta+Shift+M,none,Krohnkite: Set master";
          "KrohnkiteShiftDown" = "Meta+Shift+J,none,Krohnkite: Move Down/Next";
          "KrohnkiteShiftLeft" = "Meta+Shift+H,none,Krohnkite: Move Left";
          "KrohnkiteShiftRight" = "Meta+Shift+L,none,Krohnkite: Move Right";
          "KrohnkiteShiftUp" = "Meta+Shift+K,none,Krohnkite: Move Up/Prev";
        };

        plasmashell = {
          "activate task manager entry 1" = "none,Meta+1,Activate Task Manager Entry 1";
          "activate task manager entry 10" = "none,,Activate Task Manager Entry 10";
          "activate task manager entry 2" = "none,Meta+2,Activate Task Manager Entry 2";
          "activate task manager entry 3" = "none,Meta+3,Activate Task Manager Entry 3";
          "activate task manager entry 4" = "none,Meta+4,Activate Task Manager Entry 4";
          "activate task manager entry 5" = "none,Meta+5,Activate Task Manager Entry 5";
          "activate task manager entry 6" = "none,Meta+6,Activate Task Manager Entry 6";
          "activate task manager entry 7" = "none,Meta+7,Activate Task Manager Entry 7";
          "activate task manager entry 8" = "none,Meta+8,Activate Task Manager Entry 8";
          "activate task manager entry 9" = "none,Meta+9,Activate Task Manager Entry 9";
        };

        services = {
          "Alacritty.desktop" = {
            New = "Meta+Return";
          };
          "org.kde.krunner.desktop" = {
            _launch = "Meta+D\tSearch";
          };
        };
      };
      powerdevilrc = {
        AC = {
          Performance = {
            PowerProfile = "performance";
          };
          SuspendAndShutdown = {
            AutoSuspendAction = 0;
          };
        };
        Battery = {
          Performance = {
            PowerProfile = "balanced";
          };
        };
        LowBattery = {
          Performance = {
            PowerProfile = "power-saver";
          };
        };
      };
      dolphinrc = {
        General = {
          EditableUrl = true;
          ShowFullPath = true;
          ShowStatusBar = "FullWidth";
          ShowZoomSlider = true;
        };
      };
    };
  };
}
