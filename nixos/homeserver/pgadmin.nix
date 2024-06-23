{config, ...}: {
  sops.secrets = {
    "services/pgadmin/password" = {};
  };
  services = {
    pgadmin = {
      enable = true;
      initialEmail = "fabian.koehler@proton.me";
      initialPasswordFile = config.sops.secrets."services/pgadmin/password".path;
    };
  };
}
