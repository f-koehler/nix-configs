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
  healthchecksBase = "https://health.${nodeConfig.domain}/ping/";
  healthchecksSlug = "homeserver-sanoid-paperless";
  script-export-documents = pkgs.writeShellScriptBin "${name}-export-documents" ''
    #!/run/current-system/sw/bin/bash
    set -euf -o pipefail
    /run/current-system/sw/bin/chown -R ${config.services.paperless.user}:${config.services.paperless.user} /backup
    /run/wrappers/bin/sudo -u ${config.services.paperless.user} -g ${config.services.paperless.user} /run/current-system/sw/bin/bash -c "/run/current-system/sw/bin/paperless-manage document_exporter -z -zn paperless-documents /backup/"
  '';
  script-pre-backup = pkgs.writeShellScriptBin "${name}-pre-backup" ''
    #!${lib.getExe' pkgs.bash "bash"}
    set -euf -o pipefail
    PING_KEY=$(< ${config.sops.secrets."services/healthchecks/ping_key".path})
    ${lib.getExe' pkgs.curl "curl"} -fsS -m 10 --retry 5 -o /dev/null "${healthchecksBase}/$PING_KEY/${healthchecksSlug}/start?create=1"
    ${lib.getExe' pkgs.openssh "ssh"} -o StrictHostKeyChecking=accept-new root@${ip} "${lib.getExe script-export-documents}"
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
  hostName = "docs";
  inherit (config.services.paperless) port;
  bindMounts = {
    "${config.sops.secrets."services/paperless/admin/password".path}".isReadOnly = true;
    "${config.sops.secrets."services/healthchecks/ping_key".path}".isReadOnly = true;
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
  sanoidPreScript = script-pre-backup;
  sanoidPostScript = script-post-backup;
}
// {
  sops.secrets = {
    "services/healthchecks/ping_key" = {
      owner = "sanoid";
      group = "sanoid";
    };
    "services/paperless/admin/password" = { };
  };
}
