{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.isLinux {
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    uninstallUnused = true;
    update = {
      auto = {
        enable = true;
        onCalendar = "daily";
      };
      onActivation = false;
    };
    packages = [
      {
        appId = "com.discordapp.Discord";
        origin = "flathub";
      }
      {
        appId = "com.jgraph.drawio.desktop";
        origin = "flathub";
      }
      {
        appId = "io.github.alainm23.planify";
        origin = "flathub";
      }
      {
        appId = "net.werwolv.ImHex";
        origin = "flathub";
      }
      {
        appId = "org.fkoehler.KTailctl";
        origin = "flathub";
      }
      {
        appId = "org.gimp.GIMP";
        origin = "flathub";
      }
      {
        appId = "org.inkscape.Inkscape";
        origin = "flathub";
      }
      {
        appId = "org.jellyfin.JellyfinDesktop";
        origin = "flathub";
      }
      {
        appId = "org.libreoffice.LibreOffice";
        origin = "flathub";
      }
      {
        appId = "org.sqlitebrowser.sqlitebrowser";
        origin = "flathub";
      }
      {
        appId = "md.obsidian.Obsidian";
        origin = "flathub";
      }
    ];
  };
}
