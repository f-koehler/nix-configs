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
      ../os
    ];
  };
  mkOs = config: lib.nixosSystem (mkOsConfig (myLib.common.mkNodeConfig config));
  mkSelfHostedService =
    {
      name,
      enable ? false,
      datasets ? [ ],
      user ? name,
    }:
    lib.mkIf enable {
      disko.devices.zpool.zroot.datasets = builtins.listToAttrs (
        builtins.map (name: {
          name = "var/lib/selfHosted/${name}";
          value = {
            type = "zfs_fs";
          };
        }) datasets
      );
      users = {
        groups.${user} = { };
        users.${user} = {
          isSystemUser = true;
          group = user;
          linger = true;
          home = "/var/lib/selfHosted/${user}";
          createHome = true;
        };
      };
    };
in
{
  inherit mkOsConfig mkOs mkSelfHostedService;
}
