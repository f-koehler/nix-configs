{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  noctaliaPackage = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  noctaliaExe = "${lib.getExe' noctaliaPackage "noctalia"}";
in
{
  home.packages = [
    pkgs.bluetui
    pkgs.wiremix
    pkgs.networkmanager
    pkgs.brightnessctl
  ];

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };

  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      allow_images = true;
      insensitive = true;
    };
  };

  programs.noctalia = {
    enable = true;
    settings = {
      bar = {
        default = {
          radius = 0;
          shadow = false;
          thickness = 28;
          margin_ends = 0;
          start = [ "workspaces" ];
          center = [
            "cpu-graph"
            "temp"
            "ram"
            "disk"
          ];
          end = [
            "media"
            "tray"
            "notifications"
            "clipboard"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
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
        default.path = "/usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png";
      };
      widget = {
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

  services = {
    flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
        };
      };
    };
    kanshi = {
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
  };

  wayland = {
    systemd.target = "sway-session.target";

    windowManager.sway =
      let
        modifier = "Mod4";
      in
      {
        enable = true;
        package = null;

        config = {
          inherit modifier;

          terminal = "${lib.getExe' config.programs.ghostty.package "ghostty"}";

          menu = "${noctaliaExe} msg panel-toggle launcher";

          focus = {
            followMouse = false;
          };

          keybindings = lib.mkOptionDefault {
            "${modifier}+Shift+e" = lib.mkForce "exec ${noctaliaExe} msg panel-toggle session";
            "${modifier}+comma" = "exec ${noctaliaExe} msg settings-toggle";
            "XF86AudioRaiseVolume" = "exec ${noctaliaExe} msg volume-up";
            "XF86AudioLowerVolume" = "exec ${noctaliaExe} msg volume-down";
            "XF86AudioMute" = "exec ${noctaliaExe} msg volume-mute";
            "XF86MonBrightnessUp" = "exec ${noctaliaExe} msg brightness-up";
            "Print" = "exec ${lib.getExe' pkgs.flameshot "flameshot"} gui";
          };

          window = {
            titlebar = false;
            border = 2;
          };

          bars = [ ];
        };

        extraConfig = ''
          ${lib.optionalString config.catppuccin.sway.enable ''
            # target                title     bg    text  indicator  border
            client.focused          $lavender $base $text $rosewater $lavender
            client.focused_inactive $overlay0 $base $text $rosewater $overlay0
            client.unfocused        $overlay0 $base $text $rosewater $overlay0
            client.urgent           $peach    $base $peach $overlay0 $peach
            client.placeholder      $overlay0 $base $text $overlay0 $overlay0
            client.background       $base
          ''}

          exec env PATH="${config.home.profileDirectory}/bin:$PATH" ${noctaliaExe}
          exec ${lib.getExe' pkgs.kanshi "kanshi"}
        '';
      };
  };
}
