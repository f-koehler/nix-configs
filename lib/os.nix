{
  inputs,
  outputs,
  stateVersion,
  ...
}:
let
  common = import ./common.nix { inherit inputs outputs stateVersion; };
  mkOsConfig = nodeConfig: {
    specialArgs = {
      inherit
        inputs
        outputs
        stateVersion
        nodeConfig
        ;
    };
    modules = [ ../os ];
  };
  mkOs = config: inputs.nixpkgs.lib.nixosSystem (mkOsConfig (common.mkNodeConfig config));
  mkServiceUser = username: {
    users.users.${username} = {
      isSystemUser = true;
      group = username;
    };
    users.groups.${username} = { };
  };
in
{
  inherit mkOsConfig mkOs mkServiceUser;
}
