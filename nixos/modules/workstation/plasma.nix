{ pkgs, ... }:
{
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };

      displayManager.lightdm.enable = true;
      displayManager.lightdm.greeters.slick.enable = true;
      # displayManager.gdm.enable = true;
    };
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
      # kdePackages.krohnkite
      kdePackages.purpose
      catppuccin-cursors
      catppuccin-kde
      catppuccin-cursors
    ]
    ++ [ catppuccin-kde ];
  security.pam.services.fkoehler.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
}
