{
  lib,
  config,
  pkgs,
  ...
}:
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

    swayosd.enable = true;
  };

  wayland = {
    systemd.target = "sway-session.target";

    windowManager.sway = {
      enable = true;
      package = null;

      config = {
        modifier = "Mod4";

        terminal = "${lib.getExe' config.programs.ghostty.package "ghostty"}";

        # GIO hides desktop entries whose Exec binary isn't on PATH, and the
        # sway session's PATH lacks the nix profile, so add it for the launcher.
        menu = ''PATH="${config.home.profileDirectory}/bin:$PATH" ${lib.getExe' config.programs.wofi.package "wofi"} --show drun'';

        focus = {
          followMouse = false;
        };

        output = {
          "*" = {
            bg = "/usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill";
          };
        };

        # Most keybindings (workspaces, moving/resizing containers, layout,
        # scratchpad, ...) come from the module's built-in defaults, which
        # already mirror the stock /etc/sway/config bindings almost exactly.
        bars = [
          {
            position = "top";
            statusCommand = "while date +'%Y-%m-%d %X'; do sleep 1; done";
          }
        ];
      };

      # Bindings that need flags (--locked) not expressible via config.keybindings.
      extraConfig =
        let
          swayosd = lib.getExe' pkgs.swayosd "swayosd-client";
        in
        ''
          exec swayosd-server

          # Audio
          bindsym XF86AudioRaiseVolume exec ${swayosd} --output-volume raise 5
          bindsym XF86AudioLowerVolume exec ${swayosd} --output-volume lower -5
          bindsym XF86AudioMute exec ${swayosd} --output-volume mute-toggle
          bindsym XF86AudioMicMute exec ${swayosd} --input-volume mute-toggle

          # Capslock and friends
          bindsym --release Caps_Lock exec ${swayosd} --caps-lock
          bindsym --release Num_Lock exec ${swayosd} --num-lock
          bindsym --release Scroll_Lock exec ${swayosd} --scroll-lock

          # Brightness
          bindsym XF86MonBrightnessUp exec ${swayosd} --brightness +5
          bindsym XF86MonBrightnessDown exec ${swayosd} --brightness -5

          # Media playback
          bindsym XF86AudioPlay exec ${swayosd} --playerctl play-pause
          bindsym XF86AudioNext exec ${swayosd} --playerctl next
          bindsym XF86AudioPrev exec ${swayosd} --playerctl previous

          bindsym Print exec ${lib.getExe' pkgs.grim "grim"}
        '';
    };
  };
}
