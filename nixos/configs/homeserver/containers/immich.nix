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
  script-dump-db = pkgs.writeShellScriptBin "${name}-dump-db" ''
    #!/run/current-system/sw/bin/bash
    set -euf -o pipefail
    /run/current-system/sw/bin/chown -R ${config.services.immich.user}:${config.services.immich.group} /db_backup
    /run/wrappers/bin/sudo -u ${config.services.immich.user} -g ${config.services.immich.group} /run/current-system/sw/bin/bash -c "/run/current-system/sw/bin/pg_dump --dbname=${config.services.immich.database.name} --compress=gzip:level=9 --file=/db_backup/immich.psql.gz"
  '';
  script-pre-backup = pkgs.writeShellScriptBin "${name}-pre-backup" ''
    #!${lib.getExe' pkgs.bash "bash"}
    set -euf -o pipefail
    ${lib.getExe' pkgs.openssh "ssh"} -o StrictHostKeyChecking=accept-new root@${ip} "${lib.getExe script-dump-db}"
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
}
