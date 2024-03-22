{config, ...}: {
  services.borgbackup = {
    repos = {
      jellyfin = {
        user = "${config.services.jellyfin.user}";
        group = "${config.services.jellyfin.group}";
        quota = "50G";
        path = "/media/tank0/backups/homeserver/jellyfin";
      };
    };
    jobs = {
      jellyfin = {
        paths = ["/var/lib/jellyfin"];
        repo = "jellyfin";
        startAt = "daily";
        persistentTime = true;
        user = "${config.services.jellyfin.user}";
        group = "${config.services.jellyfin.group}";
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
