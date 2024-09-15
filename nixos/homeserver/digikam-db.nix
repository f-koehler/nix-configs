{config, ...}: let
  port = 33306;
in {
  sops = {
    secrets = {
      "services/digikam_db/password" = {};
    };
    templates = {
      # Digikam DB initialization script from documentation: https://docs.digikam.org/en/setup_application/database_settings.html#the-mysql-remote-server
      "digikam_db_initial_script.sql".content = ''
        CREATE USER 'digikam'@'%' IDENTIFIED BY '${config.sops.placeholder."services/digikam_db/password"}';
        GRANT ALL ON *.* TO 'digikam'@'%' IDENTIFIED BY '${config.sops.placeholder."services/digikam_db/password"}';
        CREATE DATABASE digikam;
        GRANT ALL PRIVILEGES ON digikam.* TO 'digikam'@'%';
        FLUSH PRIVILEGES;
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [port];
  containers.digikam-db = {
    ephemeral = true;
    autoStart = true;
    forwardPorts = [
      {
        hostPort = port;
        containerPort = 3306;
      }
    ];
    bindMounts = {
      "/var/lib/mysql" = {
        hostPath = "/containers/digikam-db";
        isReadOnly = false;
      };
      "/share/digikam_db/initial_script.sql" = {
        hostPath = config.sops.templates."digikam_db_initial_script.sql".path;
        isReadOnly = true;
      };
    };
    config = {
      pkgs,
      lib,
      ...
    }: {
      services = {
        mysql = {
          enable = true;
          package = pkgs.mariadb;
          settings = {
            mysqld = {
              max_allowed_packet = "128M";
              bind_address = "0.0.0.0";
            };
          };
          initialScript = "/share/digikam_db/initial_script.sql";
        };
        resolved.enable = true;
      };
      networking.useHostResolvConf = lib.mkForce false;
    };
  };
  fileSystems = {
    "/containers/digikam-db" = {
      device = "rpool/digikam-db";
      fsType = "zfs";
    };
  };
}
