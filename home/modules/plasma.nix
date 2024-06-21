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
      lookAndFeel = "org.kde.breezedark.desktop";
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
  };
}
