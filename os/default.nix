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

    inputs.home-manager.nixosModules.home-manager
    ./navidrome.nix
  ];

  boot = {
    zfs = {
      forceImportRoot = false;
      devNodes = "/dev/disk/by-path";
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        efiSupport = true;
        zfsSupport = true;
        #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
        mirroredBoots = [
          {
            path = "/boot";
            devices = [ "nodev" ];
          }
          {
            path = "/boot-fallback";
            devices = [ "nodev" ];
          }
        ];
      };
    };
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  networking = {
    inherit (nodeConfig) domain hostName hostId;
  };
  nixpkgs = {
    hostPlatform = nodeConfig.system;
  };
  services = {
    openssh = {
      enable = true;

    };
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
