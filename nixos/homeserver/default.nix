{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./audiobookshelf.nix
    # ./digikam-db.nix
    ./hardware.nix
    ./homepage.nix
    ./invidious.nix
    ./jellyfin.nix
    ./navidrome.nix
    ./nextcloud.nix
    ./nginx.nix
    ./paperless.nix
    ./postgresql.nix
    ./samba.nix
    ./tinymediamanager.nix
    # ./uptime-kuma.nix
    ./zfs-snapshots.nix
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
      isNormalUser = true;
      group = "${username}";
      extraGroups = [
        "wheel"
        "media"
        "libvirtd"
      ];
      packages = with pkgs; [
        tmux
      ];
      shell = pkgs.fish;
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
