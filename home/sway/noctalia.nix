{
  config,
  hasAnyTagOf,
  hasTag,
  lib,
  ...
}:
{
  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        programs.noctalia = {
          enable = true;
          settings = {
            brightness = {
              enable_ddcutil = true;
            };
            bar = {
              main = {
                radius = 0;
                shadow = false;
                thickness = 28;
                margin_ends = 0;
                start = [
                  "workspaces"
                  "media"
                ];
                center = [
                  "cpu-graph"
                  "temp"
                  "ram"
                  "disk"
                ];
                end = [
                  "tray"
                  "notifications"
                  "clipboard"
                  "network"
                  "bluetooth"
                  "volume"
                ]
                ++ lib.optionals (hasTag "laptop") [
                  "brightness"
                  "battery"
                ]
                ++ [
                  "control-center"
                  "session"
                  "clock"
                ];
              };
            };
            location = {
              address = "Singapore";
            };
            theme = {
              mode = "dark";
              source = "builtin";
              builtin = "Catppuccin";
            };
            wallpaper = {
              enabled = true;
              directory = "${config.home.homeDirectory}/Wallpapers";
              automation = {
                enabled = true;
                interval_seconds = 1800;
                order = "random";
                recursive = true;
              };
            };
            widget = {
              clock = {
                type = "clock";
                format = "{:%Y-%m-%d} {:%H:%M}";
              };
              cpu-graph = {
                type = "sysmon";
                stat = "cpu_usage";
                visualization = "graph";
              };
              temp = {
                type = "sysmon";
                stat = "cpu_temp";
                visualization = "graph";
              };
              ram = {
                type = "sysmon";
                stat = "ram_used";
                visualization = "graph";
              };
              disk = {
                type = "sysmon";
                stat = "disk_used_pct";
                path = "/";
              };
            };
          };
        };
      };
}
