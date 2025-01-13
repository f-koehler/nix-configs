{
  config,
  pkgs,
  ...
}:
{
  sops = {
    secrets = {
      "services/digikam_db/password" = { };
    };
    templates = {
      # Digikam DB initialization modified from Digikam documentation: https://docs.digikam.org/en/setup_application/database_settings.html#the-mysql-remote-server
      "digikam_db_initial_script.sql".content = ''
        CREATE USER 'digikam'@'%' IDENTIFIED BY '${config.sops.placeholder."services/digikam_db/password"}';
        GRANT ALL ON *.* TO 'digikam'@'%' IDENTIFIED BY '${
          config.sops.placeholder."services/digikam_db/password"
        }';
        CREATE DATABASE digikam;
        GRANT ALL PRIVILEGES ON digikam.* TO 'digikam'@'%';
        FLUSH PRIVILEGES;
      '';
    };
  };
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
      initialScript = config.sops.templates."digikam_db_initial_script.sql".path;
    };
  };
  fileSystems = {
    "/var/lib/mariadb" = {
      device = "rpool/mariadb";
      fsType = "zfs";
    };
  };
}
