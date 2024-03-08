_: {
  services = {
    postgresql.enable = true;
    postgresqlBackup = {
      enable = true;
      pgdumpOptions = "-C";
      backupAll = true;
    };
  };
}
