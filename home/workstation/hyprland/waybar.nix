{
  lib,
  pkgs,
  ...
}: {
  programs = {
    waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      catppuccin = {
        enable = true;
        flavor = "mocha";
      };
      settings = [
        {
          position = "top";
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "tray"
            "wireplumber"
            "pulseaudio"
            "bluetooth"
            "network"
            "battery"
            "backlight"
            "power-profiles-deamon"
          ];
          "hyprland/workspaces" = {
            active-only = false;
            all-outputs = false;
            on-click = "activate";
          };
          "tray" = {
            icon-size = 20;
            spacing = 12;
          };
          wireplumber = {
            scroll-step = 5;
            format = "<big>{icon}</big>";
            format-alt = "<big>{icon}</big> <small>{volume}󰏰</small>";
            format-muted = "󰖁";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            max-volume = 100;
            on-click-middle = "${pkgs.avizo}/bin/volumectl toggle-mute";
            on-click-right = "hyprctl dispatch exec [workspace current] ${lib.getExe pkgs.pwvucontrol}";
            on-scroll-up = "${pkgs.avizo}/bin/volumectl -u up 2";
            on-scroll-down = "${pkgs.avizo}/bin/volumectl -u down 2";
            tooltip-format = "󰓃  {volume}󰏰\n󰒓  {node_name}";
          };
          pulseaudio = {
            format = "<big>{format_source}</big>";
            format-alt = "<big>{format_source}</big> <small>{source_volume}󰏰</small>";
            format-source = "󰍰";
            format-source-muted = "󰍱";
            on-click-middle = "${pkgs.avizo}/bin/volumectl -m toggle-mute";
            on-click-right = "hyprctl dispatch exec [workspace current] ${lib.getExe pkgs.pwvucontrol}";
            on-scroll-up = "${pkgs.avizo}/bin/volumectl -m up 2";
            on-scroll-down = "${pkgs.avizo}/bin/volumectl -m down 2";
            tooltip-format = "  {source_volume}󰏰\n󰒓  {desc}";
          };
          network = {
            format = "<big>{icon}</big>";
            format-alt = " <small>{bandwidthDownBits}</small>  <small>{bandwidthUpBits}</small>";
            format-ethernet = "󰈀";
            format-disconnected = "󱚵";
            format-linked = "";
            format-wifi = "󰖩";
            interval = 2;
            on-click-right = "hyprctl dispatch exec [workspace current] ${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
            tooltip-format = "  {ifname}\n󰩠  {ipaddr} via {gwaddr}\n  {bandwidthDownBits}\t  {bandwidthUpBits}";
            tooltip-format-wifi = "󱛁  {essid} \n󰒢  {signalStrength}󰏰\n󰩠  {ipaddr} via {gwaddr}\n  {bandwidthDownBits}\t  {bandwidthUpBits}";
            tooltip-format-ethernet = "󰈀  {ifname}\n󰩠  {ipaddr} via {gwaddr})\n  {bandwidthDownBits}\t  {bandwidthUpBits}";
            tooltip-format-disconnected = "󱚵  disconnected";
          };
          bluetooth = {
            format = "<big>{icon}</big>";
            format-connected = "󰂱";
            format-disabled = "󰂲";
            format-on = "󰂯";
            format-off = "󰂲";
            #on-click-middle = "${lib.getExe bluetoothToggle}";
            on-click-right = "hyprctl dispatch exec [workspace current] ${pkgs.blueberry}/bin/blueberry";
            tooltip-format = "  {controller_alias}\t󰿀  {controller_address}\n󰂴  {num_connections} connected";
            tooltip-format-connected = "  {controller_alias}\t󰿀  {controller_address}\n󰂴  {num_connections} connected\n{device_enumerate}";
            tooltip-format-disabled = "󰂲  {controller_alias}\t󰿀  {controller_address}\n󰂳  {status}";
            tooltip-format-enumerate-connected = "󰂱  {device_alias}\t󰿀  {device_address}";
            tooltip-format-enumerate-connected-battery = "󰂱  {device_alias}\t󰿀  {device_address} (󰥉  {device_battery_percentage}󰏰)";
            tooltip-format-off = "󰂲  {controller_alias}\t󰿀  {controller_address}\n󰂳  {status}";
          };
        }
      ];
      style = ''
        * {
          font-family: Cascadia Code NF;
          font-size: 22px;
          min-height: 0;
        }
      '';
    };
  };
}
