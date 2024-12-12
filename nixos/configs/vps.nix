{
  config,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = [
    pkgs.curl
    pkgs.git
    pkgs.mbuffer # for syncoid
    pkgs.lzop # for syncoid
  ];

  sops = {
    secrets = {
      "syncoid/ssh_key" = {
        inherit (config.services.syncoid) user;
        inherit (config.services.syncoid) group;
      };
    };
  };

  services = {
    syncoid = {
      enable = true;
      commonArgs = ["--no-sync-snap"];
      interval = "daily";
      sshKey = config.sops.secrets."syncoid/ssh_key".path;
      commands = {
        "homeserver-paperless" = {
          source = "root@homeserver:rpool/paperless";
          target = "rpool/backups/homeserver/paperless";
        };
        "homeserver-nextcloud" = {
          source = "root@homeserver:rpool/nextcloud";
          target = "rpool/backups/homeserver/nextcloud";
        };
        "homeserver-postgresql" = {
          source = "root@homeserver:rpool/postgresql";
          target = "rpool/backups/homeserver/postgresql";
        };
      };
    };
    zfs = {
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
  };

  networking.hostId = "168fda19";
}
