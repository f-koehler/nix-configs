{
  inputs,
  outputs,
  stateVersion,
  ...
}:
let
  myLib = rec {
    os = import ./os.nix {
      inherit
        inputs
        outputs
        stateVersion
        myLib
        ;
    };
    home = import ./home.nix {
      inherit
        inputs
        outputs
        stateVersion
        myLib
        ;
    };
    common = import ./common.nix {
      inherit
        inputs
        outputs
        stateVersion
        myLib
        ;
    };
    forEachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
    getNixpkgs =
      system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    getNixpkgsStable =
      system:
      import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
  };
in
myLib
