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
      "com.spotify.Client"
      "com.valvesoftware.Steam"
      "md.obsidian.Obsidian"
      "org.fkoehler.KTailctl"
      "us.zoom.Zoom"
    ];
  };
}
