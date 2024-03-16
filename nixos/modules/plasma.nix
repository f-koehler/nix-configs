_: {
  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };

      # Enable the KDE Plasma Desktop Environment.
      displayManager.sddm.enable = true;
    };
    desktopManager.plasma6.enable = true;
  };
}
