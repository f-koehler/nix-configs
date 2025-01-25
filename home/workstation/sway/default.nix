{ lib, isLinux, ... }:
{
  imports = lib.optionals isLinux [
    ./sway.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swaync.nix
    ./swayosd.nix
  ];
}
