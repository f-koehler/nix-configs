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

  port = 8000;
  name = "vaultwarden";
  ip = "172.22.1.123";
  healthchecksBase = "https://health.${nodeConfig.domain}/ping/";
  healthchecksSlug = "homeserver-sanoid-vaultwarden";
  script-create-backup = pkgs.writeShellScriptBin "${name}-export-documents" ''
    #!/run/current-system/sw/bin/bash
    set -euf -o pipefail
    /run/current-system/sw/bin/chown -R vaultwarden:vaultwarden /backup
    /run/wrappers/bin/sudo -u vaultwarden -g vaultwarden /run/current-system/sw/bin/sqlite3 /var/lib/vaultwarden/db.sqlite3 ".backup '/backup/db.sqlite3'"
    /run/wrappers/bin/sudo -u vaultwarden -g vaultwarden /run/current-system/sw/bin/rsync -avP --delete /var/lib/vaultwarden/attachments /var/lib/vaultwarden/sends /backup/
    /run/wrappers/bin/sudo -u vaultwarden -g vaultwarden /run/current-system/sw/bin/rsync -avP /var/lib/vaultwarden/rsa_key.pem /backup/
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
in
libContainer.mkContainer rec {
  inherit name ip;
  hostName = "vault";
  inherit port;
  bindMounts = {
    "${config.sops.templates."env".path}".isReadOnly = true;
    "${config.sops.secrets."services/healthchecks/ping_key".path}".isReadOnly = true;
    "/backup" = {
      hostPath = "/containers/${name}/backup";
      isReadOnly = false;
    };
  };
  extraConfig = _: {
    services = {
      vaultwarden = {
        enable = true;
        dbBackend = "sqlite";
        config = {
          DOMAIN = "https://${hostName}.${nodeConfig.domain}";
          EMERGENCY_ACCESS_ALLOWED = true;
          EMAIL_CHANGE_ALLOWED = true;
          ROCKET_PORT = port;
        };
        environmentFile = "${config.sops.templates."env".path}";
      };
    };
    environment.systemPackages = [
      pkgs.sqlite
      pkgs.rsync
    ];
  };
  sanoidDataset = "rpool/containers/${name}/backup";
  sanoidPreScript = script-pre-backup;
  sanoidPostScript = script-post-backup;
}
// {
  sops = {
    secrets = {
      "services/vaultwarden/admin_token" = { };
      "services/healthchecks/ping_key" = { };
    };
    templates."env" = {
      content = ''
        ADMIN_TOKEN=${config.sops.placeholder."services/vaultwarden/admin_token"}
      '';
    };
  };
}
