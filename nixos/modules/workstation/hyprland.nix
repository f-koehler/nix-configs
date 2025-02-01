{
  inputs,
  pkgs,
  nodeConfig,
  ...
}:
{
  environment.systemPackages = [ pkgs.hyprpolkitagent ];
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${nodeConfig.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${nodeConfig.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };
    uwsm = {
      enable = true;
    };
  };
  services = {
    blueman.enable = true;
    devmon.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    dbus = {
      implementation = "broker";
    };
  };
}
