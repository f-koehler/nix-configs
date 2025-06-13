{
  pkgs,
  nodeConfig,
  lib,
  ...
}:
{
  imports = [
    ./homeserver
  ];
  fileSystems = {
    "/" = {
      device = "rpool/root";
      fsType = "zfs";
    };

    "/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };
  };

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    zfs.extraPools = [
      "tank0"
      "tank1"
    ];
  };

  services.zfs = {
    trim = {
      enable = true;
      interval = "weekly";
    };
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    autoSnapshot.enable = false;
  };

  networking = {
    interfaces."enp3s0".ipv4.addresses = [
      {
        address = "192.168.1.92";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp3s0";
    };
  };

  users = {
    groups = {
      media = {
        gid = 985;
      };
      "${nodeConfig.username}" = { };
    };
    users."${nodeConfig.username}" = {
      extraGroups = [
        "media"
        "libvirtd"
      ];
      packages = with pkgs; [
        tmux
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    gitFull
    tmux
    exfatprogs
    htop
    home-manager
    devenv
    lzop # for syncoid
    mbuffer # for syncoid
  ];
}
