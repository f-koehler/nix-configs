{ pkgs, ... }: {
  programs = {
    seahorse.enable = true;
    sway = {
      enable = true;
      xwayland.enable = true;
      extraOptions = [ "--unsupported-gpu" ];
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
    };
  };
  services = {
    displayManager = {
      noctalia-greeter.enable = true;
    };
    flatpak.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = false;
    };
    greetd = {
      enable = true;
    };
    libinput.enable = true;
    printing.enable = true;
  };
  hardware.i2c.enable = true;
  xdg.portal.enable = true;
  environment.systemPackages = with pkgs; [
    deskflow
    gimp
    imhex
    inkscape
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.filelight
    kdePackages.kcharselect
    kdePackages.okular
    libreoffice
    sqlitebrowser
    telegram-desktop

    kdePackages.qt6ct
    libsForQt5.qt5ct
    kdePackages.breeze
    kdePackages.qqc2-breeze-style
    kdePackages.breeze-icons
  ];
  qt.platformTheme = "qt5ct";
}
