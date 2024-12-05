_: {
  imports = [
    ./bluetooth.nix
    ./distrobox.nix
    # ./hyprland.nix
    ./ios.nix
    ./packages.nix
    ./plasma.nix
    # ./sshfs.nix
    ./samba-shares.nix
    ./sound.nix
    # ./sway.nix
    ./wine.nix
  ];
  services = {
    libinput.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
  };
}
