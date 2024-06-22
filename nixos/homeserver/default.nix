{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./atuin.nix
    ./audiobookshelf.nix
    ./gickup.nix
    ./hardware.nix
    ./home-assistant.nix
    ./homepage.nix
    ./jellyfin.nix
    ./nextcloud.nix
    ./nginx.nix
    ./paperless.nix
    ./samba.nix
    # ./stirling-pdf.nix
    ./tinymediamanager.nix
    ./uptime-kuma.nix
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
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
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
  };

  users = {
    groups = {
      media = {
        gid = 985;
      };
      fkoehler = {};
    };
    users.fkoehler = {
      isNormalUser = true;
      group = "fkoehler";
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
  ];
}