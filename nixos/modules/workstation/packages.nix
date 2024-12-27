{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      # bitwarden-desktop
      chromium
      distrobox
      evince
      firefox
      gimp
      gvfs
      inkscape
      jellyfin-media-player
      kate
      kdePackages.plasma-browser-integration
      krdc
      libreoffice-fresh
      localsend
      nextcloud-client
      protonmail-bridge
      super-productivity
      telegram-desktop
      thunderbird
      vlc
      vscode
      xfce.thunar
      xfce.thunar-volman
      zotero
      exiftool
      digikam
      ktorrent
      vistafonts
      corefonts
    ];
  };
}
