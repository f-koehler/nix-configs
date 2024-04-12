{
  pkgs,
  isWorkstation,
  lib,
  ...
}: {
  programs.plasma = lib.mkIf (pkgs.stdenv.isLinux && isWorkstation) {
    enable = true;
    workspace = {
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";
    };
    hotkeys.commands."launch-wezterm" = {
      name = "Launch wezterm";
      key = "Meta+Return";
      command = "wezterm";
    };
    configFile = {
      "baloofilerc"."Basic Settings"."Indexing-Enabled".value = false;
    };
  };
}
