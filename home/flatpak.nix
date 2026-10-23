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
  # Minimal INI reader: { group = { key = value; }; } for a KDE .colors file.
  parseIni =
    text:
    (lib.foldl'
      (
        acc: line:
        let
          header = builtins.match "[[](.*)[]]" line;
          pair = builtins.match "([^=]+)=(.*)" line;
        in
        if header != null then
          acc // { group = lib.head header; }
        else if pair != null && acc.group != null then
          lib.recursiveUpdate acc { out.${acc.group}.${lib.elemAt pair 0} = lib.elemAt pair 1; }
        else
          acc
      )
      {
        group = null;
        out = { };
      }
      (lib.splitString "\n" text)
    ).out;
  colorScheme =
    let
      flavor = lib.toSentenceCase config.catppuccin.flavor;
      accent = lib.toSentenceCase config.catppuccin.accent;
      package = pkgs.catppuccin-kde.override {
        flavour = [ config.catppuccin.flavor ];
        accents = [ config.catppuccin.accent ];
        winDecStyles = [ "modern" ];
      };
    in
    parseIni (builtins.readFile "${package}/share/color-schemes/Catppuccin${flavor}${accent}.colors");
in
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  # The sandboxed KDE apps read ~/.config/kdeglobals (see kdeOverride). Inline
  # the catppuccin colour scheme, since apps can't resolve it by name inside
  # the sandbox. qt.kde.settings merges via kwriteconfig6, so an existing
  # (mutable) kdeglobals is updated rather than clobbered.
  qt.kde.settings.kdeglobals = lib.recursiveUpdate colorScheme {
    Icons.Theme = config.gtk.iconTheme.name;
    KDE.widgetStyle = "Breeze";
  };
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
      "org.kde.kcharselect" = kdeOverride;
      "org.kde.okular" = kdeOverride;
      "org.kde.ark" = kdeOverride;
      "org.fkoehler.KTailctl" = kdeOverride;
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
        appId = "org.kde.kcharselect";
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
      {
        appId = "org.telegram.desktop";
        origin = "flathub";
      }
    ];
  };
}
