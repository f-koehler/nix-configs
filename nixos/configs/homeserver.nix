{
  pkgs,
  username,
  ...
}: {
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
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    zfs.extraPools = ["tank0" "tank1"];
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

  users = {
    groups = {
      media = {
        gid = 985;
      };
      "${username}" = {};
    };
    users."${username}" = {
      extraGroups = [
        "media"
        "libvirtd"
      ];
      packages = with pkgs; [
        tmux
      ];
    };
  };
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    gitFull
    tmux
    exfatprogs
    htop
    home-manager
    devenv
  ];
}