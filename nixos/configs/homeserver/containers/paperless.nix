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
  name = "paperless";
  ip = "172.22.1.122";
  # script-dump-db = pkgs.writeShellScriptBin "${name}-dump-db" ''
  #   #!${lib.getExe' pkgs.bash "bash"}
  #   set -euf -o pipefail
  #   ${lib.getExe' pkgs.sudo "sudo"} -u ${config.services.immich.user} -g ${config.services.immich.group} ${lib.getExe' pkgs.bash "bash"} -c "${lib.getExe' config.services.postgresql.package "pg_dump"} --dbname=${config.services.immich.database.name} --compress=gzip:level=9 --file=/db_backup/immich.psql.gz"
  # '';
  # script-pre-backup = pkgs.writeShellScriptBin "${name}-pre-backup" ''
  #   #!${lib.getExe' pkgs.bash "bash"}
  #   set -euf -o pipefail
  #   ${lib.getExe' pkgs.openssh "ssh"} -o StrictHostKeyChecking=accept-new root@${ip} "${lib.getExe script-dump-db}"
  # '';
in
libContainer.mkContainer rec {
  inherit name ip;
  hostName = "docs";
  inherit (config.services.paperless) port;
  bindMounts = {
    "${config.sops.secrets."services/paperless/admin/password".path}".isReadOnly = true;
    "/backup" = {
      hostPath = "/containers/${name}/backup";
      isReadOnly = false;
    };
  };
  extraConfig = _: {
    services = {
      paperless = {
        enable = true;
        inherit port;
        inherit (config.services.paperless) user;
        passwordFile = config.sops.secrets."services/paperless/admin/password".path;
        database.createLocally = true;
        openMPThreadingWorkaround = true;
        configureTika = true;
        settings = {
          PAPERLESS_URL = "https://${hostName}.${nodeConfig.domain}";
          PAPERLESS_ADMIN_USER = "${nodeConfig.username}";
          PAPERLESS_OCR_LANGUAGE = "deu+eng";
          PAPERLESS_OCR_USER_ARGS = {
            invalidate_digital_signatures = true;
          };
          PAPERLESS_TASK_WORKERS = 2;
          PAPERLESS_THREADS_PER_WORKER = 2;
          PAPERLESS_TIME_ZONE = "Asia/Singapore";
        };
      };
    };
  };
  sanoidDataset = "rpool/containers/${name}/backup";
  # sanoidPreScript = script-pre-backup;
}
// {
  sops.secrets = {
    "services/paperless/admin/password" = { };
  };
}
