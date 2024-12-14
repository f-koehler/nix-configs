{
  outputs,
  lib,
  stateVersion,
  nodeConfig,
  ...
}: {
  imports =
    [
      ./disks/${nodeConfig.hostname}.nix
      ./configs/${nodeConfig.hostname}.nix
      ./modules/common
    ]
    ++ lib.optional nodeConfig.isWorkstation ./modules/workstation
    ++ lib.optional (builtins.pathExists ./hardware/${nodeConfig.hostname}.nix) ./hardware/${nodeConfig.hostname}.nix;
  networking.hostName = nodeConfig.hostname;
  sops.defaultSopsFile = ../secrets/${nodeConfig.hostname}.yaml;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  system.stateVersion = stateVersion;
}
