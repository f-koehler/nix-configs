{
  inputs,
  outputs,
  stateVersion,
  myLib,
  ...
}:
let
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
    modules = [ ../os ];
  };
  mkOs = config: inputs.nixpkgs.lib.nixosSystem (mkOsConfig (myLib.common.mkNodeConfig config));
  mkServiceUser = username: {
    users.users = {
      ${username} = {
        isNormalUser = true;
        group = username;
        linger = true;
      };
    };
    users.groups = {
      ${username} = { };
    };
  };
in
{
  inherit mkOsConfig mkOs mkServiceUser;
}
