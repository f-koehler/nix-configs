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
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      wallpaper = {
        enabled = true;
        default.path = "/usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png";
      };
    };
  };

  services = {
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
        in
        [
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
        ];
    };
  };

  wayland = {
    systemd.target = "sway-session.target";

    windowManager.sway = {
      enable = true;
      package = null;

      config = {
        modifier = "Mod4";

        terminal = "${lib.getExe' config.programs.ghostty.package "ghostty"}";

        menu = "${noctaliaExe} msg panel-toggle launcher";

        focus = {
          followMouse = false;
        };

        bars = [ ];
      };

      # Bindings that need flags (--locked) not expressible via config.keybindings.
      extraConfig = ''
        exec ${noctaliaExe}

        set $ipc ${noctaliaExe} msg

        bindsym ${config.wayland.windowManager.sway.config.modifier}+comma exec $ipc settings-toggle

        bindsym --locked XF86AudioRaiseVolume exec $ipc volume-up
        bindsym --locked XF86AudioLowerVolume exec $ipc volume-down
        bindsym --locked XF86AudioMute exec $ipc volume-mute
        bindsym --locked XF86MonBrightnessUp exec $ipc brightness-up
        bindsym --locked XF86MonBrightnessDown exec $ipc brightness-down

        exec ${lib.getExe' pkgs.kanshi "kanshi"}
      '';
    };
  };
}
