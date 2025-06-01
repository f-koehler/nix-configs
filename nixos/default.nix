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
      inputs.nixos-facter-modules.nixosModules.facter
      inputs.sops-nix.nixosModules.sops
      inputs.catppuccin.nixosModules.catppuccin
      inputs.home-manager.nixosModules.home-manager
      ./disks/${nodeConfig.hostname}.nix
      ./configs/${nodeConfig.hostname}.nix
      ./modules/common
    ]
    ++ lib.optional nodeConfig.isWorkstation ./modules/workstation
    ++ lib.optional (builtins.pathExists ./configs/${nodeConfig.hostname}.nix) ./configs/${nodeConfig.hostname}.nix
    ++ lib.optional (builtins.pathExists ./hardware/${nodeConfig.hostname}.nix) ./hardware/${nodeConfig.hostname}.nix
    ++ lib.optional (builtins.pathExists ./disks/${nodeConfig.hostname}.nix) ./disks/${nodeConfig.hostname}.nix;
  networking.hostName = nodeConfig.hostname;
  sops.defaultSopsFile = ../secrets/${nodeConfig.hostname}.yaml;

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = nodeConfig.system;
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
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableAllFirmware = true;
  system.stateVersion = stateVersion;
  documentation.man.generateCaches = true;
}
