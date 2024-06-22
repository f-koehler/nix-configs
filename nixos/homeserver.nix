{
  config,
  inputs,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ./homeserver
    ./common
  ];

  sops.defaultSopsFile = ../secrets/homeserver.yaml;

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

  # Use the systemd-boot EFI boot loader.
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

  networking.hostName = "homeserver"; # Define your hostname.

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

  programs.nix-ld = {
    enable = true;
    package = inputs.nix-ld-rs.packages."${pkgs.system}".nix-ld-rs;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.additions
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    gitFull
    tmux
    exfatprogs
    htop
    home-manager
  ];

  system.stateVersion = "23.11";
}
