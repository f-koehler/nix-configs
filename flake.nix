{
  description = "An empty flake template that you can adapt to your own environment";

  # Flake inputs
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    systems.url = "github:nix-systems/default";
  };

  # Flake outputs
  outputs =
    { self, ... }@inputs:
    let
      forEachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
      getNixpkgs = (
        system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in
    {
      devShells = forEachSystem (system: {
        default =
          let
            pkgs = getNixpkgs system;
          in
          pkgs.mkShell {

            packages = with pkgs; [ ];
            env = { };
            shellHook = "";
          };
      });
    };
}
