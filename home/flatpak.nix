{
  config,
  lib,
  pkgs,
  ...
}:
let
  # The KDE runtime ships its own "kde" platform theme, which reads kdeglobals.
  # qt6ct's plugin is not available inside the sandbox.
  kdeOverride = {
    Context.filesystems = [
      "xdg-config/kdeglobals:ro"
      # icon theme symlinks in ~/.local/share/icons point into the store
      "/nix/store:ro"
    ];
    Environment = {
      QT_QPA_PLATFORMTHEME = "kde";
      XDG_CURRENT_DESKTOP = "KDE";
    };
  };
in
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  # Flatpak exposes ~/.local/share/icons to apps, but not the nix profile.
  # Link the catppuccin-flavoured Papirus (see theme.nix) there.
  xdg.dataFile = lib.genAttrs [ "icons/Papirus" "icons/Papirus-Dark" ] (path: {
    source = "${config.gtk.iconTheme.package}/share/${path}";
  });
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
    overrides.settings = {
      "org.kde.dolphin" = kdeOverride;
      "org.kde.okular" = kdeOverride;
      "org.kde.ark" = kdeOverride;
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
      {
        appId = "org.deskflow.deskflow";
        origin = "flathub";
      }
      {
        appId = "org.kde.dolphin";
        origin = "flathub";
      }
      {
        appId = "org.kde.okular";
        origin = "flathub";
      }
      {
        appId = "org.kde.ark";
        origin = "flathub";
      }
    ];
  };
}
