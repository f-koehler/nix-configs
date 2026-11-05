{
  lib,
  config,
  hasAnyTagOf,
  hasTag,
  pkgs,
  ...
}:
let
  qtctSettings = {
    Appearance = {
      style = "Breeze";
      icon_theme = config.gtk.iconTheme.name;
      standard_dialogs = "default";
    };
    Fonts = {
      general = "Noto Sans,12";
      fixed = "Noto Sans,12";
    };
  };
  noctaliaExe = "${lib.getExe' pkgs.noctalia "noctalia"}";
  swaymsg = lib.getExe' pkgs.sway "swaymsg";
  lidClosed = pkgs.writeShellScript "sway-lid-closed" ''
    others="$(${swaymsg} -t get_outputs -r | ${lib.getExe pkgs.jq} '[.[] | select(.active and .name != "eDP-1")] | length')"
    [ "$others" -gt 0 ] && ${swaymsg} output eDP-1 disable
  '';
in
{
  imports = [
    ./flameshot.nix
    ./kanshi.nix
    ./noctalia.nix
  ];

  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        home.packages = [
          pkgs.ddcutil
          pkgs.bluetui
          pkgs.wiremix
          pkgs.networkmanager
          pkgs.brightnessctl
          pkgs.wl-clipboard
        ];

        qt = {
          enable = true;
          platformTheme.name = "kde";
          qt6ctSettings = qtctSettings;
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
              systemd.xdgAutostart = true;

              config = {
                inherit modifier;

                bars = [ ];
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
                input."type:keyboard" = {
                  xkb_layout = "us,de";
                  xkb_options = "grp:alt_shift_toggle";
                };
                menu = "${noctaliaExe} msg panel-toggle launcher";
                terminal = "${lib.getExe' config.programs.ghostty.package "ghostty"}";
                window = {
                  titlebar = false;
                  border = 2;
                  commands = [
                    {
                      command = "floating enable";
                      criteria = {
                        app_id = "com.nextcloud.desktopclient.nextcloud";
                        title = "^Select the source folder";
                      };
                    }
                    {
                      command = "floating enable";
                      criteria = {
                        app_id = "soffice";
                        title = "^Text Import.*";
                      };
                    }
                    {
                      command = "floating enable";
                      criteria = {
                        app_id = "org.keepassxc.KeePassXC";
                        title = ".*Browser Access Request$";
                      };
                    }
                    {
                      command = "floating enable";
                      criteria = {
                        app_id = "org.kde.kcharselect";
                      };
                    }
                  ];
                };
                workspaceAutoBackAndForth = true;

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

                exec env PATH="${config.home.profileDirectory}/bin:$PATH" ${noctaliaExe} --daemon
                exec ${lib.getExe' pkgs.kanshi "kanshi"}

                # Lid closed: turn off the internal display, but only when another output remains.
                # Lid opened: let kanshi re-apply the matching profile.
                ${lib.optionalString (hasTag "laptop") ''
                  bindswitch --locked lid:on exec ${lidClosed}
                  bindswitch --locked lid:off exec ${lib.getExe' pkgs.kanshi "kanshictl"} reload
                ''}
              '';
            };
        };
      };
}
