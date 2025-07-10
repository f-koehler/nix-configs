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
  inherit (config.services.healthchecks) port user group;
  # script-dump-db = pkgs.writeShellScriptBin "${name}-dump-db" ''
  #   #!/run/current-system/sw/bin/bash
  #   set -euf -o pipefail
  #   /run/current-system/sw/bin/chown -R ${config.services.immich.user}:${config.services.immich.group} /db_backup
  #   /run/wrappers/bin/sudo -u ${config.services.immich.user} -g ${config.services.immich.group} /run/current-system/sw/bin/bash -c "/run/current-system/sw/bin/pg_dump --dbname=${config.services.immich.database.name} --compress=gzip:level=9 --file=/db_backup/immich.psql.gz"
  # '';
  # script-pre-backup = pkgs.writeShellScriptBin "${name}-pre-backup" ''
  #   #!${lib.getExe' pkgs.bash "bash"}
  #   set -euf -o pipefail
  #   ${lib.getExe' pkgs.openssh "ssh"} -o StrictHostKeyChecking=accept-new root@${ip} "${lib.getExe script-dump-db}"
  # '';
in
libContainer.mkContainer rec {
  inherit name ip;
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
  };
  # sanoidDataset = "rpool/containers/${name}/db_backup";
  # sanoidPreScript = script-pre-backup;
}
// {
  sops = {
    secrets = {
      "services/healthchecks/secret_key" = { };
    };
  };
}
