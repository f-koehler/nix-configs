{
  inputs,
  outputs,
  stateVersion,
  myLib,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;
  mkOsConfig = nodeConfig: {
    specialArgs = {
      inherit
        inputs
        outputs
        stateVersion
        nodeConfig
        myLib
        ;
    };
    modules = [
      inputs.sops-nix.nixosModules.sops
      inputs.disko.nixosModules.disko
      inputs.nixos-facter-modules.nixosModules.facter
      inputs.home-manager.nixosModules.home-manager
      inputs.quadlet-nix.nixosModules.quadlet
      inputs.sops-nix.nixosModules.sops
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
      ../os
    ];
  };
  mkOs = config: lib.nixosSystem (mkOsConfig (myLib.common.mkNodeConfig config));
  mkSelfHostedService =
    {
      name,
      enable ? false,
      datasets ? [ ],
      containers ? { },
      tailscale ? {
        enable = false;
        serveHost = null;
        servePort = null;
      },
    }:
    lib.mkIf enable {
      disko.devices.zpool.zroot.datasets = builtins.listToAttrs (
        builtins.map (dataset: {
          name = "var/lib/selfHosted/${dataset}";
          value = {
            type = "zfs_fs";
            options.acltype = "posixacl";
          };
        }) ([ "${name}" ] ++ (map (dataset: "${name}/${dataset}") datasets))
      );
      users = {
        groups.${name} = { };
        users.${name} = {
          isNormalUser = true;
          group = name;
          extraGroups = [
            "systemd-journal"
            "quadlet"
          ];
          linger = true;
          home = "/var/lib/selfHosted/${name}";
          createHome = true;
          autoSubUidGidRange = true;
        };
      };
      systemd.tmpfiles.settings = {
        "10-home-directory-${name}" = {
          "/var/lib/selfHosted/${name}" = {
            "Z" = {
              user = name;
              group = name;
            };
          };
        };
      };
      home-manager.users.${name} =
        { pkgs, config, ... }:
        {
          imports = [
            inputs.quadlet-nix.homeManagerModules.quadlet
            inputs.sops-nix.homeManagerModules.sops
          ];
          home = {
            username = name;
            homeDirectory = "/var/lib/selfHosted/${name}";
            inherit stateVersion;
          };
          programs.home-manager.enable = true;
          sops = {
            defaultSopsFile = ../.secrets.yaml;
            age.keyFile = "/home/.age-quadlet.txt";
            secrets."services/tailscale/client_secret" = { };
            templates."tailscale.env".content = ''
              TS_USERSPACE=true
              TS_AUTHKEY=${config.sops.placeholder."services/tailscale/client_secret"}?ephemeral=true
              TS_EXTRA_ARGS=--advertise-tags=tag:homeserver-container
              TS_HOSTNAME=${name}
              TS_SERVE_CONFIG=/ts-serve.json
            '';
          };
          virtualisation.quadlet =
            let
              inherit (config.virtualisation.quadlet) pods;
            in
            {
              pods.${name} = {
                autoStart = true;
              };
              containers = lib.mkMerge [
                (lib.mapAttrs (_: containerCfg: {
                  containerConfig = containerCfg // {
                    pod = pods.${name}.ref;
                  };
                }) containers)
                {
                  # };
                  proxy = lib.mkIf tailscale.enable {
                    containerConfig = {
                      image = "tailscale/tailscale:stable";
                      pod = pods.${name}.ref;
                      environmentFiles = [ config.sops.templates."tailscale.env".path ];
                      volumes =
                        let
                          tsServeConfig = pkgs.writeTextFile {
                            name = "${name}-ts-serve.json";
                            text = ''
                              {
                                "TCP": {
                                  "443": {
                                    "HTTPS": true
                                  }
                                },
                                "Web": {
                                  "''${TS_CERT_DOMAIN}:443": {
                                    "Handlers": {
                                      "/": {
                                        "Proxy": "http://${tailscale.serveHost}:${toString tailscale.servePort}"
                                      }
                                    }
                                  }
                                },
                                "AllowFunnel": {
                                  "''${TS_CERT_DOMAIN}:443": false
                                }
                              }
                            '';
                          };
                        in
                        [
                          "${tsServeConfig}:/ts-serve.json:Z"
                        ];
                    };
                  };
                }
              ];
            };
        };
    };
in
{
  inherit mkOsConfig mkOs mkSelfHostedService;
}
