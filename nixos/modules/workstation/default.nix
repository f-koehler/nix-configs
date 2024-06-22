_: {
  imports = [
    ./bluetooth.nix
    ./distrobox.nix
    ./packages.nix
    ./plasma.nix
    ./sound.nix
    ./sway.nix
    ./wine.nix
  ];
  services = {
    libinput.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
  };
}
