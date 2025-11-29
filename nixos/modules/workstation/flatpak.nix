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
      "com.github.tchx84.Flatseal"
      "com.nextcloud.desktopclient.nextcloud"
      "com.obsproject.Studio"
      "com.super_productivity.SuperProductivity"
      "org.fkoehler.KTailctl"
      "org.gimp.GIMP"
      "org.inkscape.Inkscape"
      "org.telegram.desktop"
      "org.telegram.desktop.webview"
      "org.videolan.VLC"
      "org.zotero.Zotero"
      "us.zoom.Zoom"
    ];
  };
}
