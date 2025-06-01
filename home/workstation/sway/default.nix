{
  lib,
  config,
  nodeConfig,
  ...
}:
{
  imports = [
    ./rofi.nix
    # ./kanshi.nix
    ./swayosd.nix
    ./swaync.nix
    # ./swaylock.nix
    # ./swayidle.nix
  ];
  catppuccin.sway = {
    enable = true;
    flavor = "mocha";
  };
  services.network-manager-applet.enable = true;
  services.gnome-keyring.enable = true;
  wayland = {
    #   systemd.target = "graphical-session.target";
    windowManager.sway = {
      enable = true;
      #     systemd.enable = false; # we use UWSM for session management
      extraOptions = lib.optionals (builtins.elem "nvidia" nodeConfig.gpus) [ "--unsupported-gpu" ];
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      xwayland = true;
      config = {
        modifier = "Mod4";
        menu = "${lib.getExe' config.programs.rofi.finalPackage "rofi"} -show drun";
        terminal = "${lib.getExe' config.programs.alacritty.package "alacritty"}";
        focus = {
          followMouse = false;
          mouseWarping = true;
        };
        fonts = {
          names = config.fonts.fontconfig.defaultFonts.sansSerif;
          size = "${toString nodeConfig.fontSize}";
        };
        gaps = {
          smartBorders = "on";
          smartGaps = false;
        };
        window.titlebar = false;
        workspaceAutoBackAndForth = true;
        workspaceOutputAssign = [
          {
            workspace = "1";
            output = "DP-1,eDP-1";
          }
          {
            workspace = "2";
            output = "DP-1,eDP-1";
          }
          {
            workspace = "3";
            output = "DP-1,eDP-1";
          }
          {
            workspace = "4";
            output = "DP-1,eDP-1";
          }
          {
            workspace = "5";
            output = "DP-1,eDP-1";
          }
          {
            workspace = "6";
            output = "eDP-1";
          }
          {
            workspace = "7";
            output = "eDP-1";
          }
          {
            workspace = "8";
            output = "eDP-1";
          }
          {
            workspace = "9";
            output = "eDP-1";
          }
          {
            workspace = "10";
            output = "eDP-1";
          }
        ];
        colors = {
          background = "$base";
          focused = {
            border = "$lavender";
            background = "$base";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$lavender";
          };
          focusedInactive = {
            border = "$overlay0";
            background = "$base";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$overlay0";
          };
          unfocused = {
            border = "$overlay0";
            background = "$base";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$overlay0";
          };
          urgent = {
            border = "$peach";
            background = "$base";
            text = "$peach";
            indicator = "$overlay0";
            childBorder = "$peach";
          };
          placeholder = {
            border = "$overlay0";
            background = "$base";
            text = "$text";
            indicator = "$overlay0";
            childBorder = "$overlay0";
          };
        };
        bars = [
          {
            fonts = {
              names = config.fonts.fontconfig.defaultFonts.sansSerif;
              size = "${toString nodeConfig.fontSize}";
            };
            colors = {
              background = "$base";
              statusline = "$text";
              focusedStatusline = "$text";
              focusedSeparator = "$base";

              activeWorkspace = {
                border = "$base";
                background = "$surface2";
                text = "$text";
              };
              focusedWorkspace = {
                border = "$base";
                background = "$mauve";
                text = "$crust";
              };
              inactiveWorkspace = {
                border = "$base";
                background = "$base";
                text = "$text";
              };
              urgentWorkspace = {
                border = "$base";
                background = "$red";
                text = "$crust";
              };
            };
          }
        ];
      };
      # extraConfigEarly = ''
      #   set $rosewater #f5e0dc
      #   set $flamingo #f2cdcd
      #   set $pink #f5c2e7
      #   set $mauve #cba6f7
      #   set $red #f38ba8
      #   set $maroon #eba0ac
      #   set $peach #fab387
      #   set $yellow #f9e2af
      #   set $green #a6e3a1
      #   set $teal #94e2d5
      #   set $sky #89dceb
      #   set $sapphire #74c7ec
      #   set $blue #89b4fa
      #   set $lavender #b4befe
      #   set $text #cdd6f4
      #   set $subtext1 #bac2de
      #   set $subtext0 #a6adc8
      #   set $overlay2 #9399b2
      #   set $overlay1 #7f849c
      #   set $overlay0 #6c7086
      #   set $surface2 #585b70
      #   set $surface1 #45475a
      #   set $surface0 #313244
      #   set $base #1e1e2e
      #   set $mantle #181825
      #   set $crust #11111b
      # '';
    };
  };
}
