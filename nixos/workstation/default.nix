# Desktop/laptop specifics, added by mkNode to every node without the `server` tag.
{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/common/pc"
    inputs.catppuccin.nixosModules.catppuccin
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./btrfs.nix
    ./desktop.nix
    ./firmware.nix
    ./gaming.nix
    ./networking.nix
    ./power.nix
    ./user.nix
  ];
}
