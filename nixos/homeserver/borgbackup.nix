{config, ...}: {
  services.borgbackup = {
    repos = {
      jellyfin = {
        user = "${config.users.jellyfin.user}";
        group = "${config.users.jellyfin.group}";
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
        user = "${config.users.jellyfin.user}";
        group = "${config.users.jellyfin.group}";
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
