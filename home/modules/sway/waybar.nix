{pkgs, ...}: let
  swaync = pkgs.swaynotificationcenter;
in {
  programs.waybar = {
    enable = true;
    systemd.target = "sway-session.target";
    settings = {
      mainBar = {
        height = 34;
        spacing = 15;
        modules-left = ["sway/workspaces" "sway/mode"];
        modules-right = ["custom/notifications" "tray" "clock" "battery#BAT0"];
        tray = {
          spacing = 5;
        };
        "custom/notification" = {
          "tooltip" = false;
          "format" = "{icon}";
          "format-icons" = {
            "notification" = "<span foreground='red'><sup></sup></span>";
            "none" = "";
            "dnd-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-none" = "";
            "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "";
          };
          "return-type" = "json";
          "exec" = "${swaync}/bin/swaync-client -swb";
          "on-click" = "${swaync}/bin/swaync-client -t -sw";
          "on-click-right" = "${swaync}/bin/swaync-client -d -sw";
          "escape" = true;
        };
      };
    };
    style = ''
      * {
        font-family: Noto Sans, Cascadia Mono NF;
        font-size: 18px;
      }
    '';
  };
}
