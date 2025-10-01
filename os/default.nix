{
  inputs,
  nodeConfig,
  stateVersion,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disks/${nodeConfig.hostName}.nix

    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./hardware/${nodeConfig.hostName}.json; }
  ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      efiSupport = true;
      #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
      device = "nodev";
    };
  };

  networking = {
    inherit (nodeConfig) domain hostName hostId;
  };
  nixpkgs = {
    hostPlatform = nodeConfig.system;
  };
  time.timeZone = nodeConfig.timezone;
  users = {
    groups.${nodeConfig.username} = { };
    users.${nodeConfig.username} = {
      isNormalUser = true;
      group = "${nodeConfig.username}";
      extraGroups = [ "wheel" ];
    };
  };
  system = {
    inherit stateVersion;
  };
}
