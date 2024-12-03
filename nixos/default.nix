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

  facter.reportPath =
    if builtins.pathExists ../nixos/hardware/${hostname}.json
    then ./hardware/${hostname}.json
    else throw "Missing facter.json for host ${hostname}";

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  system.stateVersion = stateVersion;
}
