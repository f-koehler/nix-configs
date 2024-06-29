{pkgs, ...}: {
  home.packages = with pkgs; [swaynotificationcenter];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        # modules-left = ["sway/workspaces" "sway/mode"];
        # modules-right = ["custom/notifications" "tray" "clock" "battery#BAT0"];
      };
    };
    style = ''
      * {
        font-family: Cascadia Mono NF;
        font-size: 14px;
      }
    '';
  };
}
