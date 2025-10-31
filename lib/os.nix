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
          imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];
          home = {
            username = name;
            homeDirectory = "/var/lib/selfHosted/${name}";
            inherit stateVersion;
          };
          programs.home-manager.enable = true;
          virtualisation.quadlet =
            let
              inherit (config.virtualisation.quadlet) pods;
            in
            {
              pods.navidrome = {
                autoStart = true;
              };
              containers = {
                app = {
                  containerConfig = {
                    image = "deluan/navidrome:0.58.0";
                    pod = pods.navidrome.ref;
                  };
                };
              };
            };
        };
    };
in
{
  inherit mkOsConfig mkOs mkSelfHostedService;
}
