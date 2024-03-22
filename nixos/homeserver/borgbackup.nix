{config, ...}: {
  services.borgbackup = {
    jobs = {
      jellyfin = {
        path = "/media/tank0/backups/homeserver/jellyfin";
        paths = ["/var/lib/jellyfin"];
        startAt = "daily";
        persistentTime = true;
        user = "${config.users.jellyfin.user}";
        group = "${config.users.jellyfin.group}";
        quota = "50G";
        inhibitsSleep = true;
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
