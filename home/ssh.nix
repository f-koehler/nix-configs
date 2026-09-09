{
  config,
  lib,
  hasTag,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = lib.optional (hasTag "speqtral") config.sops.secrets."ssh/internal_hosts".path;
    settings = {
      "Host homeserver" = {
        User = "fkoehler";
        HostName = "homeserver.corgi-dojo.ts.net";
      };
    };
  };

  sops.secrets."ssh/internal_hosts" = lib.mkIf (hasTag "speqtral") {
    sopsFile = ./../secrets/speqtral.yaml;
  };
}
