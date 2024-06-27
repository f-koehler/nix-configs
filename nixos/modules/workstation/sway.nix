{pkgs, ...}: {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
  };
  security.polkit.enable = true;
  hardware.graphics.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
  };
}
