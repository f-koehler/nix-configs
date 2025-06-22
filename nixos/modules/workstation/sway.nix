{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs = {
    sway = {
      enable = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      xwayland.enable = true;
      extraOptions = [ "--unsupported-gpu" ];
    };
    uwsm = {
      enable = true;
      waylandCompositors = {
        "sway" = {
          prettyName = "Sway";
          comment = "Sway window manager with UWSM session management";
          binPath = lib.getExe' config.programs.sway.package "sway";
        };
      };
    };
  };
  services = {
    blueman.enable = true;
    devmon.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    dbus.implementation = "broker";
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
  security = {
    polkit.enable = true;
    pam.services.swaylock = { };
    pam.services.sddm.enableGnomeKeyring = true;
  };
  hardware.graphics.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    wlr.enable = true;
    xdgOpenUsePortal = true;
  };
}
