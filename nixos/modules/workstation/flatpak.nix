{inputs, ...}: {
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
      "com.spotify.Client"
      "com.valvesoftware.Steam"
      "io.github.dweymouth.supersonic"
      "md.obsidian.Obsidian"
      "org.fkoehler.KTailctl"
      "org.musicbrainz.Picard"
      "us.zoom.Zoom"
    ];
  };
}
