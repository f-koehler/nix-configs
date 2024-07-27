{config, ...}: {
  sops = {
    secrets = {
      "services/jellystat/password" = {
        owner = "jellyfin";
        group = "jellyfin";
      };
      "services/jellystat/db/password" = {
        owner = "jellyfin";
        group = "jellyfin";
      };
      "services/jellystat/jwt" = {
        owner = "jellyfin";
        group = "jellyfin";
      };
    };
    templates."jellystat.env" = {
      owner = "jellyfin";
      group = "jellyfin";
      content = ''
        POSTGRES_USER=jellystat
        POSTGRES_PASSWORD=${config.sops.placeholder."services/jellystat/db/password"}
        POSTGRES_DB=jfstat
        POSTGRES_IP=jellystat_db
        JS_USER=fkoehler
        JS_PASSWORD=${config.sops.placeholder."services/jellystat/password"}
        JWT_SECRET=${config.sops.placeholder."services/jellystat/jwt"}
        TZ=Asian/Singapore
      '';
    };
  };
  virtualisation.oci-containers.containers = {
    "jellystat_db" = {
      image = "docker.io/library/postgres:16.3";
      volumes = [
        "/var/lib/jellystat/db:/var/lib/postgresql/data"
      ];
      environmentFiles = ["${config.sops.templates."jellystat.env".path}"];
    };
    "jellystat" = {
      image = "docker.io/cyfershepard/jellystat:latest";
      dependsOn = ["jellystat_db"];
      volumes = [
        "/var/lib/jellystat/app:/app/backend/backup-data"
      ];
      ports = [
        "127.0.0.1:18300:3000"
      ];
      environmentFiles = ["${config.sops.templates."jellystat.env".path}"];
    };
  };
}
