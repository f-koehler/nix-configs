{
  inputs,
  outputs,
  lib,
  stateVersion,
  nodeConfig,
  pkgs,
  ...
}:
{
  imports =
    [
      inputs.disko.nixosModules.disko
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      inputs.determinate.nixosModules.default
      ../stylix.nix
      ./disks/${nodeConfig.hostname}.nix
      ./configs/${nodeConfig.hostname}.nix
      ./modules/common
    ]
    ++ lib.optional nodeConfig.isWorkstation ./modules/workstation
    ++ lib.optional (builtins.pathExists ./configs/${nodeConfig.hostname}.nix) ./configs/${nodeConfig.hostname}.nix
    ++ lib.optional (builtins.pathExists ./hardware/${nodeConfig.hostname}.nix) ./hardware/${nodeConfig.hostname}.nix
    ++ lib.optional (builtins.pathExists ./disks/${nodeConfig.hostname}.nix) ./disks/${nodeConfig.hostname}.nix;
  networking = {
    hostName = nodeConfig.hostname;
    inherit (nodeConfig) domain;
  };
  sops.defaultSopsFile = ../secrets/${nodeConfig.hostname}.yaml;

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = nodeConfig.system;
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  stylix.targets = {
    console.enable = true;
    nixos-icons.enable = true;
  };

  hardware.enableAllFirmware = true;
  system.stateVersion = stateVersion;
  documentation.man.generateCaches = true;
}
