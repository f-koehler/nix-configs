{
  nodeConfig,
  lib,
  pkgs,
  ...
}:
{
  boot.loader = {
    grub = {
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };
  services.openssh.enable = true;

  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.networkmanager
  ];

  # put your SSH key here when installing system with nixos-anywhere, remove once installed
  users.users.root.openssh.authorizedKeys.keys = [ ];

  users = {
    groups."${nodeConfig.username}" = { };
    users."${nodeConfig.username}" = {
      linger = true;
      group = nodeConfig.username;
      extraGroups = [ "wheel" ];
      initialPassword = "test";
    };
  };
}
