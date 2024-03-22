{config, ...}: {
  sops.secrets = {
    "services/jellyfin/ssh_key" = {
      owner = "${config.services.jellyfin.user}";
      group = "${config.services.jellyfin.group}";
    };
  };
  services.borgbackup = {
    repos = {
      jellyfin = {
        user = "${config.services.jellyfin.user}";
        group = "${config.services.jellyfin.group}";
        quota = "50G";
        path = "/media/tank0/backups/homeserver/jellyfin";
        authorizedKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILRgxSe/5JyfZYKV6uF0jw65zpxYcosrua2V6qHa2h3b jellyfin@homeserver";
      };
    };
    jobs = {
      jellyfin = {
        paths = ["/var/lib/jellyfin"];
        repo = "${config.services.jellyfin.user}@localhost:/${config.services.borgbackup.repos.jellyfin.path}";
        startAt = "daily";
        persistentTime = true;
        user = "${config.services.jellyfin.user}";
        group = "${config.services.jellyfin.group}";
        inhibitsSleep = true;
        environment.BORG_RSH = "ssh -i ${config.sops.services.jellyfin.ssh_key.path}";
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
