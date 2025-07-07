{
  lib,
  pkgs,
  config,
  stateVersion,
  nodeConfig,
  ...
}:
let
  mkTailscaleServeScript =
    { name, ... }:
    let
      bash = lib.getExe' pkgs.bash "bash";
      tailscale = lib.getExe' pkgs.tailscale "tailscale";
      jq = lib.getExe' pkgs.jq "jq";
    in
    pkgs.writeShellScriptBin "${name}-tailscale-serve" ''
      #!${bash}
      set -euf -o pipefail

      while [[ "$(${tailscale} status --json --peers=false | ${jq} -r '.BackendState')" == "NoState" ]]; do
        sleep 0.5
      done
      ${tailscale} serve 80
    '';

  mkContainer =
    {
      name,
      hostName ? name,
      ip,
      port,
      extraConfig,
      bindMounts ? { },
      allowedDevices ? [ ],
      # TODO(fk): make this an attrset
      sanoidDataset ? null,
      sanoidPreScript ? null,
      sanoidPostScript ? null,
      sanoidForcePostSnapshotScript ? false,
      ...
    }:
    let
      tailscaleServeScript = mkTailscaleServeScript { inherit name port; };
    in
    {
      services = {
        sanoid = lib.optionalAttrs (sanoidDataset != null) {
          datasets."${sanoidDataset}" = {
            yearly = 2;
            monthly = 24;
            daily = 90;
            hourly = 96;
            autosnap = true;
            autoprune = true;
            pre_snapshot_script = if (sanoidPreScript != null) then "${lib.getExe sanoidPreScript}" else null;
            post_snapshot_script =
              if (sanoidPostScript != null) then "${lib.getExe sanoidPostScript}" else null;
            force_post_snapshot_script = sanoidForcePostSnapshotScript;
            no_inconsistent_snapshot = true;
            script_timeout = 0;
            recursive = true;
          };
        };
      };

      containers.${name} =
        let
          hostConfig = config;
          baseConfig = _: {
            system.stateVersion = stateVersion;
            boot.isContainer = true;
            time.timeZone = nodeConfig.timeZone;
            users = {
              groups.tailscale = { };
              users = {
                tailscale = {
                  isSystemUser = true;
                  group = "tailscale";
                };
                root.openssh.authorizedKeys.keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZhXkUJt62fOgcIyrjgFEzOEk34Q0fswDWc//ZMqbWV sanoid@homeserver"
                ];
              };
            };
            networking = {
              hostName = name;
              inherit (nodeConfig) domain;
              firewall = {
                enable = true;
                allowedTCPPorts = [
                  443
                ];
              };
            };
            services = {
              tailscale = {
                enable = true;
                authKeyFile = hostConfig.sops.secrets."services/tailscale/authKey".path;
                openFirewall = true;
                interfaceName = name;
                extraUpFlags = [
                  "--hostname=${hostName}"
                  "--operator=tailscale"
                ];
              };
              openssh = {
                enable = true;
                openFirewall = true;
                listenAddresses = [ { addr = ip; } ];
              };
              nginx = {
                enable = true;
                upstreams."${hostName}" = {
                  servers = {
                    "127.0.0.1:${toString port}" = { };
                  };
                };
                virtualHosts."${hostName}.${nodeConfig.domain}" = {
                  listen = [
                    {
                      addr = "0.0.0.0";
                      port = 80;
                    }
                  ];
                  locations = {
                    "/" = {
                      proxyPass = "http://${hostName}/";
                      extraConfig = ''
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                        proxy_set_header Host $host;
                        proxy_set_header Upgrade $http_upgrade;
                        proxy_set_header Connection "upgrade";
                        proxy_http_version 1.1;
                        proxy_redirect http:// https://;
                      '';
                    };
                  };
                };
              };
            };
            systemd = {
              services = {
                tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
                tailscale-serve = {
                  enable = true;
                  description = "Tailscale Serve";
                  requires = [
                    "tailscaled.service"
                    "tailscaled-autoconnect.service"
                  ];
                  after = [
                    "tailscaled.service"
                    "tailscaled-autoconnect.service"
                  ];
                  wantedBy = [ "multi-user.target" ];
                  serviceConfig = {
                    Type = "exec";
                    ExecStart = "${lib.getExe tailscaleServeScript}";
                    User = "tailscale";
                    Group = "tailscale";
                  };
                };
              };
            };
          };
        in
        {
          autoStart = true;
          privateNetwork = true;
          hostAddress = "172.22.1.1";
          localAddress = ip;
          additionalCapabilities = [
            "CAP_NET_ADMIN"
            "CAP_NET_RAW"
            "CAP_MKNOD"
          ];
          allowedDevices = [
            {
              node = "/dev/net/tun";
              modifier = "rwm";
            }
          ] ++ allowedDevices;
          bindMounts = {
            "${hostConfig.sops.secrets."services/tailscale/authKey".path}".isReadOnly = true;
          } // bindMounts;
          config = moduleArgs: lib.recursiveUpdate (baseConfig moduleArgs) (extraConfig moduleArgs);

        };
    };
in
{
  inherit mkContainer;
}
