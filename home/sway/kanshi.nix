{ lib, pkgs, ... }: {
  services.kanshi = {
    enable = true;
    settings =
      let
        monitors = {
          laptop = {
            make = "AU Optronics";
            model = "0xFA9B";
            serial = "Unknown";
            mode = "1920x1200@60";
            position = "0,0";
            scale = 1.0;
            transform = "normal";
          };

          home = {
            make = "LG Electronics";
            model = "LG ULTRAGEAR+";
            serial = "202NTDV2S306";
            mode = "3840x2160@60";
            position = "1920,-500";
            scale = 1.25;
            adaptiveSync = true;
            transform = "normal";
          };

          work-left = {
            make = "Dell Inc.";
            model = "DELL S2722DC";
            serial = "82CRGD3";
            mode = "2560x1440@75";
            position = "0,0";
            scale = 1.0;
            transform = "normal";
          };

          work-right = {
            make = "Dell Inc.";
            model = "DELL S2722DC";
            serial = "62CRGD3";
            mode = "2560x1440@75";
            position = "2560,0";
            scale = 1.0;
            transform = "normal";
          };
        };

        kanshiOutput =
          monitor:
          {
            criteria = "${monitor.make} ${monitor.model} ${monitor.serial}";
            mode = monitor.mode;
            position = monitor.position;
            scale = monitor.scale;
            transform = monitor.transform;
          }
          // lib.optionalAttrs (monitor ? adaptiveSync) {
            adaptiveSync = monitor.adaptiveSync;
          };

        moveWorkspacesToHome = pkgs.writeShellScript "kanshi-move-workspaces-to-home" ''
          set -eu

          output="$(
            ${lib.getExe' pkgs.sway "swaymsg"} -t get_outputs -r |
              ${lib.getExe pkgs.jq} -r \
                --arg make ${lib.escapeShellArg monitors.home.make} \
                --arg model ${lib.escapeShellArg monitors.home.model} \
                --arg serial ${lib.escapeShellArg monitors.home.serial} '
                  .[]
                  | select(
                      .make == $make
                      and .model == $model
                      and .serial == $serial
                    )
                  | .name
                '
          )"

          [ -n "$output" ] || exit 0

          for workspace in 1 2 3 4 5; do
            ${lib.getExe' pkgs.sway "swaymsg"} \
              "workspace $workspace; move workspace to output $output"
          done
        '';
        moveWorkspacesToWork = pkgs.writeShellScript "kanshi-move-workspaces-to-home" ''
          set -eu

          output="$(
            ${lib.getExe' pkgs.sway "swaymsg"} -t get_outputs -r |
              ${lib.getExe pkgs.jq} -r \
                --arg make ${lib.escapeShellArg monitors.work-right.make} \
                --arg model ${lib.escapeShellArg monitors.work-right.model} \
                --arg serial ${lib.escapeShellArg monitors.work-right.serial} '
                  .[]
                  | select(
                      .make == $make
                      and .model == $model
                      and .serial == $serial
                    )
                  | .name
                '
          )"

          [ -n "$output" ] || exit 0

          for workspace in 1 2 3 4 5; do
            ${lib.getExe' pkgs.sway "swaymsg"} \
              "workspace $workspace; move workspace to output $output"
          done

          output="$(
            ${lib.getExe' pkgs.sway "swaymsg"} -t get_outputs -r |
              ${lib.getExe pkgs.jq} -r \
                --arg make ${lib.escapeShellArg monitors.work-left.make} \
                --arg model ${lib.escapeShellArg monitors.work-left.model} \
                --arg serial ${lib.escapeShellArg monitors.work-left.serial} '
                  .[]
                  | select(
                      .make == $make
                      and .model == $model
                      and .serial == $serial
                    )
                  | .name
                '
          )"

          [ -n "$output" ] || exit 0

          for workspace in 6 7 8 9 10; do
            ${lib.getExe' pkgs.sway "swaymsg"} \
              "workspace $workspace; move workspace to output $output"
          done
        '';
      in
      [
        {
          profile = {
            name = "undocked";

            outputs = [
              (
                kanshiOutput monitors.laptop
                // {
                  status = "enable";
                }
              )
            ];

            exec = "${moveWorkspacesToHome}";
          };
        }
        {
          profile = {
            name = "home";

            outputs = [
              (
                kanshiOutput monitors.laptop
                // {
                  status = "enable";
                }
              )

              (
                kanshiOutput monitors.home
                // {
                  status = "enable";
                }
              )
            ];

            exec = "${moveWorkspacesToHome}";
          };
        }
        {
          profile = {
            name = "work";

            outputs = [
              (
                kanshiOutput monitors.laptop
                // {
                  status = "disable";
                }
              )

              (
                kanshiOutput monitors.work-left
                // {
                  status = "enable";
                }
              )
              (
                kanshiOutput monitors.work-right
                // {
                  status = "enable";
                }
              )
            ];

            exec = "${moveWorkspacesToWork}";
          };
        }
      ];
  };
}
