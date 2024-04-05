{pkgs, ...}: {
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };

      # displayManager.sddm.enable = true;
      displayManager.gdm.enable = true;
    };
    desktopManager.plasma6.enable = true;
  };
  environment.systemPackages = with pkgs; [
    kdePackages.skanpage
    kdePackages.tokodon
    kdePackages.neochat
    kdePackages.zanshin
    kdePackages.merkuro
  ];
  security.pam.services.fkoehler.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
}
