# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  inputs,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware/homeserver.nix
    # ./homeserver/downloader.nix
    ./homeserver/zfs-snapshots.nix

    # ./modules/atuin.nix
    ./modules/audiobookshelf.nix
    ./modules/collect-garbage.nix
    ./modules/firmware.nix
    ./modules/fstrim.nix
    ./modules/gickup.nix
    ./modules/home-assistant.nix
    ./modules/jellyfin.nix
    ./modules/locale.nix
    ./modules/nextcloud.nix
    ./modules/nginx.nix
    ./modules/nix.nix
    ./modules/paperless.nix
    ./modules/podman.nix
    # ./modules/samba.nix
    # ./modules/stirling-pdf.nix
    ./modules/tailscale.nix
    ./modules/tinymediamanager.nix
    ./modules/uptime-kuma.nix
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

    "/var/lib/audiobookshelf" = {
      device = "rpool/audiobookshelf";
      fsType = "zfs";
    };

    "/var/lib/nextcloud" = {
      device = "rpool/nextcloud";
      fsType = "zfs";
    };

    "/var/lib/paperless" = {
      device = "rpool/paperless";
      fsType = "zfs";
    };

    "/var/lib/postgresql" = {
      device = "rpool/postgresql";
      fsType = "zfs";
    };

    "/var/lib/tinymediamanager" = {
      device = "rpool/tinymediamanager";
      fsType = "zfs";
    };

    "/var/lib/hass" = {
      device = "rpool/hass";
      fsType = "zfs";
    };

    "/var/lib/uptime-kuma" = {
      device = "rpool/uptime-kuma";
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
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
      extraGroups = ["wheel" "media"]; # Enable ‘sudo’ for the user.
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
    # Allow unfree packages
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.additions
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    gitFull
    tmux
    exfatprogs
    htop
    home-manager
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

  systemd = {
    services = {
      # samba-smbd.after = [
      #   "media-tank0.mount"
      # ];
      # samba-nmbd.after = [
      #   "media-tank0.mount"
      # ];
      # jellyfin.after = [
      #   "media-tank0.mount"
      # ];
      nextcloud-setup.after = [
        "var-lib-nextcloud.mount"
      ];
      postgresql.after = [
        "var-lib-postgresql.mount"
      ];
      audiobookshelf.after = [
        "var-lib-audiobookshelf.mount"
      ];
      paperless-consumer.after = [
        "var-lib-paperless.mount"
      ];
      paperless-scheduler.after = [
        "var-lib-paperless.mount"
      ];
      paperless-task-queue.after = [
        "var-lib-paperless.mount"
      ];
      paperless-web.after = [
        "var-lib-paperless.mount"
      ];
      "podman-tinymediamanager".after = ["var-lib-tinymediamanager.mount"];
      "podman-hass".after = ["var-lib-hass.mount"];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
