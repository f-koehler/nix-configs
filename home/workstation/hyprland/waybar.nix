{
  lib,
  pkgs,
  ...
}: let
  symbolSize = "20";
  symbolRise = "0";
in {
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
          modules-center = [
            "clock"
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
            format = "<span font='${symbolSize}' rise='${symbolRise}'>{icon}</span>";
            format-alt = "<span font='${symbolSize}' rise='${symbolRise}'>{icon}</span> {volume}󰏰";
            format-muted = "<span font='${symbolSize}' rise='${symbolRise}'>󰖁</span>";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            max-volume = 100;
            on-click-middle = "${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
            on-click-right = "${pkgs.hyprland}/bin/hyprctl dispatch exec [workspace current] ${lib.getExe pkgs.pwvucontrol}";
            on-scroll-up = "${pkgs.swayosd}/bin/swayosd-client --output-volume raise";
            on-scroll-down = "${pkgs.swayosd}/bin/swayosd-client --output-volume lower";
            tooltip-format = "󰓃  {volume}󰏰\n󰒓  {node_name}";
          };
          pulseaudio = {
            format = "{format_source}";
            format-alt = "{format_source} {source_volume}󰏰";
            format-source = "<span font='${symbolSize}' rise='${symbolRise}'>󰍰</span>";
            format-source-muted = "<span font='${symbolSize}' rise='${symbolRise}'>󰍱</span>";
            on-click-middle = "${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";
            on-click-right = "${pkgs.hyprland}/bin/hyprctl dispatch exec [workspace current] ${lib.getExe pkgs.pwvucontrol}";
            on-scroll-up = "${pkgs.swayosd}/bin/swayosd-client --input-volume raise";
            on-scroll-down = "${pkgs.swayosd}/bin/swayosd-client --input-volume lower";
            tooltip-format = "  {source_volume}󰏰\n󰒓  {desc}";
          };
          network = {
            format = "<big>{icon}</big>";
            format-alt = " <small>{bandwidthDownBits}</small>  <small>{bandwidthUpBits}</small>";
            format-ethernet = "<span font='${symbolSize}' rise='${symbolRise}'>󰈀</span>";
            format-disconnected = "<span font='${symbolSize}' rise='${symbolRise}'>󱚵</span>";
            format-linked = "<span font='${symbolSize}' rise='${symbolRise}'></span>";
            format-wifi = "<span font='${symbolSize}' rise='${symbolRise}'>󰖩</span>";
            interval = 2;
            on-click-right = "hyprctl dispatch exec [workspace current] ${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
            tooltip-format = "  {ifname}\n󰩠  {ipaddr} via {gwaddr}\n  {bandwidthDownBits}\t  {bandwidthUpBits}";
            tooltip-format-wifi = "󱛁  {essid} \n󰒢  {signalStrength}󰏰\n󰩠  {ipaddr} via {gwaddr}\n  {bandwidthDownBits}\t  {bandwidthUpBits}";
            tooltip-format-ethernet = "󰈀  {ifname}\n󰩠  {ipaddr} via {gwaddr})\n  {bandwidthDownBits}\t  {bandwidthUpBits}";
            tooltip-format-disconnected = "󱚵  disconnected";
          };
          bluetooth = {
            format = "<span font='${symbolSize}' rise='${symbolRise}'>󰂯</span>";
            format-connected = "<span font='${symbolSize}' rise='${symbolRise}'>󰂯</span>";
            format-disabled = "<span font='${symbolSize}' rise='${symbolRise}'>󰂲</span>";
            format-on = "<span font='${symbolSize}' rise='${symbolRise}'>󰂯</span>";
            format-off = "<span font='${symbolSize}' rise='${symbolRise}'>󰂲</span>";
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
          font-size: 18px;
          min-height: 0;
        }
      '';
    };
  };
}
