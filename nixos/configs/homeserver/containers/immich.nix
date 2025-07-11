{
  lib,
  pkgs,
  config,
  stateVersion,
  nodeConfig,
  ...
}:
let
  libContainer = import ./lib.nix {
    inherit
      lib
      pkgs
      config
      stateVersion
      nodeConfig
      ;
  };
  name = "immich";
  ip = "172.22.1.100";
  healthchecksBase = "https://health.${nodeConfig.domain}/ping/";
  healthchecksSlug = "homeserver-sanoid-immich";
  script-dump-db = pkgs.writeShellScriptBin "${name}-dump-db" ''
    #!/run/current-system/sw/bin/bash
    set -euf -o pipefail
    /run/current-system/sw/bin/chown -R ${config.services.immich.user}:${config.services.immich.group} /db_backup
    /run/wrappers/bin/sudo -u ${config.services.immich.user} -g ${config.services.immich.group} /run/current-system/sw/bin/bash -c "/run/current-system/sw/bin/pg_dump --dbname=${config.services.immich.database.name} --compress=gzip:level=9 --file=/db_backup/immich.psql.gz"
  '';
  script-pre-backup = pkgs.writeShellScriptBin "${name}-pre-backup" ''
    #!${lib.getExe' pkgs.bash "bash"}
    set -euf -o pipefail
    PING_KEY=$(< ${config.sops.secrets."services/healthchecks/ping_key".path})
    ${lib.getExe' pkgs.curl "curl"} -fsS -m 10 --retry 5 -o /dev/null "${healthchecksBase}/$PING_KEY/${healthchecksSlug}/start?create=1"
    ${lib.getExe' pkgs.openssh "ssh"} -o StrictHostKeyChecking=accept-new root@${ip} "${lib.getExe script-dump-db}"
  '';
  script-post-backup = pkgs.writeShellScriptBin "${name}-post-backup" ''
    #!${lib.getExe' pkgs.bash "bash"}
    set -euf -o pipefail
    PING_KEY=$(< ${config.sops.secrets."services/healthchecks/ping_key".path})
    ${lib.getExe' pkgs.curl "curl"} -fsS -m 10 --retry 5 -o /dev/null "${healthchecksBase}/$PING_KEY/${healthchecksSlug}?create=1"
  '';
in
libContainer.mkContainer rec {
  inherit name ip;
  hostName = "photos";
  inherit (config.services.immich) port;
  bindMounts = {
    "/nextcloud-photos" = {
      hostPath = "/containers/nextcloud/data/fkoehler/files/Photos";
      isReadOnly = true;
    };
    "/db_backup" = {
      hostPath = "/containers/${name}/db_backup";
      isReadOnly = false;
    };
    "${config.sops.secrets."services/healthchecks/ping_key".path}".isReadOnly = true;
  };
  allowedDevices = [
    {
      modifier = "rwm";
      node = "/dev/dri/renderD128";
    }
  ];
  extraConfig = _: {
    services = {
      immich = {
        enable = true;
        host = "0.0.0.0";
        inherit port;
        inherit (config.services.immich) user group;
        database = { inherit (config.services.immich.database) name; };
        accelerationDevices = [ "/dev/dri/renderD128" ];
      };
    };
  };
  sanoidDataset = "rpool/containers/${name}/db_backup";
  sanoidPreScript = script-pre-backup;
  sanoidPostScript = script-post-backup;
}
// {
  sops.secrets = {
    "services/healthchecks/ping_key" = {
      owner = "sanoid";
      group = "sanoid";
    };
  };
}
