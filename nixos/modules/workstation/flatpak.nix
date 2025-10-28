{ inputs, ... }:
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      "com.microsoft.Edge"
      "com.bitwarden.desktop"
      "com.github.iwalton3.jellyfin-media-player"
      "com.github.tchx84.Flatseal"
      "com.jgraph.drawio.desktop"
      "com.nextcloud.desktopclient.nextcloud"
      "com.obsproject.Studio"
      "com.super_productivity.SuperProductivity"
      "com.transmissionbt.Transmission"
      "com.valvesoftware.Steam"
      "md.obsidian.Obsidian"
      "net.nokyan.Resources"
      "net.werwolv.ImHex"
      "org.fkoehler.KTailctl"
      "org.gimp.GIMP"
      "org.inkscape.Inkscape"
      "org.kde.kate"
      "org.kde.neochat"
      "org.kde.okular"
      "org.kde.tokodon"
      "org.libreoffice.LibreOffice"
      "org.localsend.localsend_app"
      "org.musicbrainz.Picard"
      "org.telegram.desktop"
      "org.telegram.desktop.webview"
      "org.videolan.VLC"
      "org.zotero.Zotero"
      "us.zoom.Zoom"
    ];
  };
}
