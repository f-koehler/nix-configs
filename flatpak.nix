_: {
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      "com.jgraph.drawio.desktop"
      "com.spotify.Client"
      "com.valvesoftware.Steam"
      "md.obsidian.Obsidian"
      "org.fkoehler.KTailctl"
      "org.onlyoffice.desktopeditors"
      "us.zoom.Zoom"
      "net.werwolv.ImHex"
    ];
  };
}
