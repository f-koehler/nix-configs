_: {
  imports = [
    ./bluetooth.nix
    ./distrobox.nix
    ./ios.nix
    ./packages.nix
    ./plasma.nix
    # ./sshfs.nix
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
