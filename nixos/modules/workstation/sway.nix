{pkgs, ...}: {
  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    xwayland.enable = true;
  };
  services = {
    blueman.enable = true;
    devmon.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };
  hardware.graphics.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    wlr.enable = true;
    xdgOpenUsePortal = true;
  };
}
