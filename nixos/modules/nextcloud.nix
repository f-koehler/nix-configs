{
  pkgs,
  config,
  ...
}: {
  sops.secrets = {
    "services/nextcloud/admin/password" = {};
  };
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    https = true;
    enableBrokenCiphersForSSE = false;
    autoUpdateApps.enable = true;
    enableImagemagick = true;
    configureRedis = true;
    config = {
      dbtype = "pgsql";
      adminuser = "fkoehler";
      adminpassFile = config.sops.secrets."services/nextcloud/admin/password".path;
    };
    caching.redis = true;
    database.createLocally = true;
    maxUploadSize = "20G";
    settings = {
      default_phone_region = "SG";
      trusted_domains = ["cloud.fkoehler.xyz"];
    };
  };
}
