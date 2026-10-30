{
  lib,
  pkgs,
  hasAnyTagOf,
  ...
}:
{
  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        # authorization backend, the polkit agent itself is provided by noctalia
        security.polkit.enable = true;
        programs = {
          dconf.enable = true;
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
          avahi = {
            enable = true;
            nssmdns4 = true;
          };
          flatpak.enable = true;
          gvfs.enable = true;
          gnome = {
            gnome-keyring.enable = true;
            gcr-ssh-agent.enable = false;
          };
          greetd = {
            enable = true;
          };
          libinput.enable = true;
          printing.enable = true;
          udisks2.enable = true;
        };
        hardware.i2c.enable = true;
        xdg.portal = {
          enable = true;
          extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
        };
        environment.sessionVariables.XDG_MENU_PREFIX = "plasma-";
        environment.systemPackages = with pkgs; [
          deskflow
          gimp
          imhex
          inkscape
          kdePackages.ark
          kdePackages.dolphin
          kdePackages.dolphin-plugins
          kdePackages.ffmpegthumbs
          kdePackages.gwenview
          kdePackages.kdegraphics-thumbnailers
          kdePackages.kimageformats
          kdePackages.kio-admin
          kdePackages.kio-extras
          kdePackages.kio-fuse
          kdePackages.plasma-workspace
          kdePackages.filelight
          kdePackages.kcharselect
          kdePackages.okular
          libreoffice
          samba
          sqlitebrowser
          telegram-desktop

          kdePackages.breeze
          kdePackages.qqc2-breeze-style
          kdePackages.breeze-icons
        ];
        qt = {
          enable = true;
          platformTheme = "kde";
        };
      };
}
