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
  name = "healthchecks";
  ip = "172.22.1.124";
  healthchecksBase = "https://health.${nodeConfig.domain}/ping/";
  healthchecksSlug = "homeserver-sanoid-healthchecks";
  script-create-backup = pkgs.writeShellScriptBin "${name}-create-backup" ''
    #!/run/current-system/sw/bin/bash
    set -euf -o pipefail
    /run/current-system/sw/bin/chown -R healthchecks:healthchecks /db_backup
    /run/wrappers/bin/sudo -u healthchecks -g healthchecks /run/current-system/sw/bin/sqlite3 /var/lib/healthchecks/healthchecks.sqlite ".backup '/db_backup/healthchecks.sqlite'"
  '';
  script-pre-backup = pkgs.writeShellScriptBin "${name}-pre-backup" ''
    #!${lib.getExe' pkgs.bash "bash"}
    set -euf -o pipefail
    PING_KEY=$(< ${config.sops.secrets."services/healthchecks/ping_key".path})
    ${lib.getExe' pkgs.curl "curl"} -fsS -m 10 --retry 5 -o /dev/null "${healthchecksBase}/$PING_KEY/${healthchecksSlug}/start?create=1"
    ${lib.getExe' pkgs.openssh "ssh"} -o StrictHostKeyChecking=accept-new root@${ip} "${lib.getExe script-create-backup}"
  '';
  script-post-backup = pkgs.writeShellScriptBin "${name}-post-backup" ''
    #!${lib.getExe' pkgs.bash "bash"}
    set -euf -o pipefail
    PING_KEY="$(< ${config.sops.secrets."services/healthchecks/ping_key".path})"
    ${lib.getExe' pkgs.curl "curl"} -fsS -m 10 --retry 5 -o /dev/null "${healthchecksBase}/$PING_KEY/${healthchecksSlug}?create=1"
  '';
  inherit (config.services.healthchecks) port user group;
in
libContainer.mkContainer rec {
  inherit name ip port;
  hostName = "health";
  bindMounts = {
    "/db_backup" = {
      hostPath = "/containers/${name}/db_backup";
      isReadOnly = false;
    };
    "${config.sops.secrets."services/healthchecks/secret_key".path}".isReadOnly = true;
  };
  extraConfig = _: {
    services = {
      healthchecks = {
        enable = true;
        inherit port user group;
        settings = {
          DB = "sqlite";
          SECRET_KEY_FILE = "/secrets/secret_key";
          DEBUG = true;
          CSRF_TRUSTED_ORIGINS = "https://${hostName}.${nodeConfig.domain}";
          ALLOWED_HOSTS = [
            "${hostName}.${nodeConfig.domain}"
            "127.0.0.1"
            "localhost"
          ];
          # CORS_ALLOWED_HOSTS = "${hostName}.${nodeConfig.domain}";
        };
      };
    };
    systemd.services.healthchecks-secret = {
      description = "Set permissions for healthchecks secret key file";
      wantedBy = [
        "healthchecks.service"
        "healthchecks-migration.service"
      ];
      requiredBy = [
        "healthchecks.service"
        "healthchecks-migration.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        Group = "root";
      };
      script =
        let
          coreutils = pkgs.coreutils-full;
          chown = lib.getExe' coreutils "chown";
          chmod = lib.getExe' coreutils "chmod";
          mkdir = lib.getExe' coreutils "mkdir";
          cp = lib.getExe' coreutils "cp";
        in
        ''
          ${mkdir} -p /secrets
          ${chown} -R root:root /secrets
          ${chmod} 0700 /secrets
          ${chmod} 0600 /secrets/secret_key || true
          ${cp} ${config.sops.secrets."services/healthchecks/secret_key".path} /secrets/secret_key
          ${chown} -R ${user}:${group} /secrets
          ${chmod} 0500 /secrets
          ${chmod} 0400 /secrets/secret_key
        '';
    };
    environment.systemPackages = [ pkgs.sqlite ];
  };
  sanoidDataset = "rpool/containers/${name}/db_backup";
  sanoidPreScript = script-pre-backup;
  sanoidPostScript = script-post-backup;
}
// {
  sops = {
    secrets = {
      "services/healthchecks/secret_key" = { };
    };
  };
}
