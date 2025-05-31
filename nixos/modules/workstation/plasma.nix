{
  pkgs,
  lib,
  nodeConfig,
  ...
}:
lib.mkIf (builtins.elem "plasma" nodeConfig.desktops) {
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };
  environment.systemPackages =
    let
      catppuccin-kde = pkgs.catppuccin-kde.override { flavour = [ "mocha" ]; };
    in
    with pkgs;
    [
      kdePackages.skanpage
      kdePackages.kcharselect
      kdePackages.filelight
      kdePackages.qtwayland
      kdePackages.purpose
      catppuccin-cursors
      catppuccin-kde
      catppuccin-cursors
    ]
    ++ [ catppuccin-kde ];
  security.pam.services.fkoehler.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
}
