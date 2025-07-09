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
  # script-export-documents = pkgs.writeShellScriptBin "${name}-export-documents" ''
  #   #!/run/current-system/sw/bin/bash
  #   set -euf -o pipefail
  #   /run/current-system/sw/bin/chown -R ${config.services.paperless.user}:${config.services.paperless.user} /backup
  #   /run/wrappers/bin/sudo -u ${config.services.paperless.user} -g ${config.services.paperless.user} /run/current-system/sw/bin/bash -c "/run/current-system/sw/bin/paperless-manage document_exporter -z -zn paperless-documents /backup/"
  # '';
  # script-pre-backup = pkgs.writeShellScriptBin "${name}-pre-backup" ''
  #   #!${lib.getExe' pkgs.bash "bash"}
  #   set -euf -o pipefail
  #   ${lib.getExe' pkgs.openssh "ssh"} -o StrictHostKeyChecking=accept-new root@${ip} "${lib.getExe script-export-documents}"
  # '';
in
libContainer.mkContainer rec {
  inherit name ip;
  hostName = "vault";
  inherit port;
  bindMounts = {
    "${config.sops.templates."env".path}".isReadOnly = true;
    # "/backup" = {
    #   hostPath = "/containers/${name}/backup";
    #   isReadOnly = false;
    # };
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
  };
  # sanoidDataset = "rpool/containers/${name}/backup";
  # sanoidPreScript = script-pre-backup;
}
// {
  sops = {
    secrets = {
      "services/vaultwarden/admin_token" = { };
    };
    templates."env" = {
      content = ''
        ADMIN_TOKEN=${config.sops.placeholder."services/vaultwarden/admin_token"}
      '';
    };
  };
}
