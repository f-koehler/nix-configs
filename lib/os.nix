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
      inputs.disko.nixosModules.disko
      inputs.nixos-facter-modules.nixosModules.facter
      inputs.home-manager.nixosModules.home-manager
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
          name = "var/lib/self-hosted/${dataset}";
          value = {
            type = "zfs_fs";
            options.acltype = "posixacl";
            postMountHook = "chown -R ${name}:${name} /var/lib/self-hosted/${dataset}";
          };
        }) ([ "${name}" ] ++ (map (dataset: "${name}/${dataset}") datasets))
      );
      users = {
        groups.${name} = { };
        users.${name} = {
          isNormalUser = true;
          group = name;
          linger = true;
          home = "/var/lib/self-hosted/${name}";
          createHome = true;
        };
      };
      home-manager.users.${name} = {
        home = {
          username = name;
          homeDirectory = "/var/lib/self-hosted/${name}";
          inherit stateVersion;
        };
        programs.home-manager.enable = true;
      }
      // mkUserQuadlet { inherit name; };
    };
  mkUserQuadlet =
    { name, ... }:
    {
      services.podman = {
        networks.${name} = {
          autoStart = true;
          description = "Podman network for ${name}";
          internal = true;
        };
      };
    };
in
{
  inherit mkOsConfig mkOs mkSelfHostedService;
}
