{ lib, nodeConfig, ... }:
{
  imports =
    [
      ./backlight.nix
      ./boot.nix
      ./bluetooth.nix
      ./distrobox.nix
      ./flatpak.nix
      ./packages.nix
      ./protonmail.nix
      # ./sshfs.nix
      # ./samba-shares.nix
      ./sound.nix
      ./wine.nix
    ]
    ++ lib.optionals (builtins.elem "sway" nodeConfig.desktops) [ ./sway.nix ]
    ++ lib.optionals (builtins.elem "plasma" nodeConfig.desktops) [ ./plasma.nix ];
  services = {
    libinput.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    power-profiles-daemon.enable = true;
  };
  stylix.targets = {
    gtk.enable = true;
    qt = {
      enable = true;
      platform = "kde6";
    };
  };
}
