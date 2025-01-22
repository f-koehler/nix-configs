{
  inputs,
  outputs,
  lib,
  stateVersion,
  nodeConfig,
  ...
}:
{
  imports =
    [
      inputs.disko.nixosModules.disko
      inputs.nixos-facter-modules.nixosModules.facter
      inputs.sops-nix.nixosModules.sops
      inputs.catppuccin.nixosModules.catppuccin
      inputs.home-manager.nixosModules.home-manager
      ./disks/${nodeConfig.hostname}.nix
      ./configs/${nodeConfig.hostname}.nix
      ./modules/common
    ]
    ++ lib.optional nodeConfig.isWorkstation ./modules/workstation
    ++ lib.optional (builtins.pathExists ./hardware/${nodeConfig.hostname}.nix) ./hardware/${nodeConfig.hostname}.nix;
  networking.hostName = nodeConfig.hostname;
  sops.defaultSopsFile = ../secrets/${nodeConfig.hostname}.yaml;

  nixpkgs = {
    config.allowUnfree = true;
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

  documentation.man.generateCaches = true;

  system.stateVersion = stateVersion;
}
