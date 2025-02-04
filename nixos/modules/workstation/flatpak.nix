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
      "com.bitwarden.desktop"
      "com.github.tchx84.Flatseal"
      "com.jgraph.drawio.desktop"
      "com.nextcloud.desktopclient.nextcloud"
      "com.spotify.Client"
      "com.super_productivity.SuperProductivity"
      "com.transmissionbt.Transmission"
      "com.valvesoftware.Steam"
      "io.github.dweymouth.supersonic"
      "md.obsidian.Obsidian"
      "net.werwolv.ImHex"
      "org.fkoehler.KTailctl"
      "org.gimp.GIMP"
      "org.inkscape.Inkscape"
      "org.kde.okular"
      "org.libreoffice.LibreOffice"
      "org.localsend.localsend_app"
      "org.mozilla.Thunderbird"
      "org.musicbrainz.Picard"
      "org.telegram.desktop"
      "org.telegram.desktop.webview"
      "org.videolan.VLC"
      "org.zotero.Zotero"
      "us.zoom.Zoom"
      "org.kde.kate"
      "com.github.iwalton3.jellyfin-media-player"
    ];
  };
}
