{
  nodeConfig,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    loader = {
      grub = {
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
      };
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
    };
  };

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
    };
  };

  services = {
    openssh.enable = true;
    open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = 11112;
    };
    ollama = {
      enable = true;
      port = 11111;
      host = "0.0.0.0";
      acceleration = "cuda";
      loadModels = [
        "deepseek-r1:14b"
        "llama4:16x17b"
      ];
    };
  };
}
