{pkgs, ...}: let
  retries = 20;
  interval = 1;
in {
  home.packages = with pkgs; [
    # blueman
    kanshi
    swayosd
    swaynotificationcenter
    # networkmanagerapplet
    waybar
  ];
  systemd.user.services = {
    # blueman-applet = {
    #   Unit = {
    #     Description = "Bluetooth management";
    #     Documentation = "man:blueman-applet(1)";
    #     StartLimitIntervalSec = interval;
    #     StartLimitBurst = retries;
    #   };
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.blueman}/bin/blueman-applet";
    #     Restart = "on-failure";
    #   };
    # };
    kanshi = {
      Unit = {
        Description = "Dynamic output configuration";
        Documentation = "man:kanshi(1)";
        StartLimitIntervalSec = interval;
        StartLimitBurst = retries;
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.kanshi}/bin/kanshi";
      };
    };
    # networkmanagerapplet = {
    #   Unit = {
    #     Description = "Network management";
    #     Documentation = "man:nm-applet(1)";
    #     StartLimitIntervalSec = interval;
    #     StartLimitBurst = retries;
    #   };
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.networkmanagerapplet}/bin/networkmanagerapplet --indicator";
    #     Restart = "on-failure";
    #   };
    # };
    swaync = {
      Unit = {
        Description = "Swaync notification daemon";
        Documentation = "man:swaync(1)";
        StartLimitIntervalSec = interval;
        StartLimitBurst = retries;
      };
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
        Restart = "on-failure";
      };
    };
    swayosd = {
      Unit = {
        Description = "Volume/backlight OSD indicator";
        Documentation = "man:swayosd(1)";
        StartLimitIntervalSec = interval;
        StartLimitBurst = retries;
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
        Restart = "on-failure";
      };
    };
    waybar = {
      Unit = {
        Description = "Status bar";
        Documentation = "man:waybar(1)";
        StartLimitIntervalSec = interval;
        StartLimitBurst = retries;
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
      };
    };
  };
}
