{config, ...}: {
  sops.secrets = {
    "services/jellyfin/ssh_key" = {
      owner = "${config.services.jellyfin.user}";
      group = "${config.services.jellyfin.group}";
    };
  };
  systemd = {
    mounts = [
      {
        description = "Mount tank0 external USB disk (Borg)";
        what = "/dev/disk/by-label/tank0-borg";
        where = "/media/tank0_borg";
        type = "exfat";
        wantedBy = ["multi-user.target"];
        options = "noatime,uid=borg,gid=borg,umask=0";
      }
    ];
    services = {
      borgbackup-repo-jellyfin.after = ["media-tank0_borg.mount"];
    };
  };
  services.borgbackup = {
    repos = {
      jellyfin = {
        user = "${config.services.jellyfin.user}";
        group = "${config.services.jellyfin.group}";
        quota = "50G";
        path = "/media/tank0/backups/homeserver/jellyfin";
        authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILRgxSe/5JyfZYKV6uF0jw65zpxYcosrua2V6qHa2h3b jellyfin@homeserver"];
      };
    };
    jobs = {
      jellyfin = {
        paths = ["/var/lib/jellyfin"];
        repo = "${config.services.jellyfin.user}@localhost:/${config.services.borgbackup.repos.jellyfin.path}";
        encryption.mode = "none";
        startAt = "daily";
        persistentTimer = true;
        user = "${config.services.jellyfin.user}";
        group = "${config.services.jellyfin.group}";
        inhibitsSleep = true;
        environment.BORG_RSH = "ssh -i ${config.sops.secrets."services/jellyfin/ssh_key".path}";
        prune.keep = {
          within = "14d";
          daily = 1;
          weekly = 0;
          monthly = 0;
        };
      };
    };
  };
}
