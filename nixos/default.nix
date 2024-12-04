{
  hostname,
  lib,
  isWorkstation,
  stateVersion,
  ...
}: {
  imports =
    [
      ./disks/${hostname}.nix
      ./configs/${hostname}.nix
      ./modules/common
    ]
    ++ lib.optional isWorkstation ./modules/workstation
    ++ lib.optional (builtins.pathExists ./hardware/${hostname}.nix) ./hardware/${hostname}.nix;
  networking.hostName = hostname;
  sops.defaultSopsFile = ../secrets/${hostname}.yaml;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  system.stateVersion = stateVersion;
}
