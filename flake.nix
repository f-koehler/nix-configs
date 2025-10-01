{
  description = "An empty flake template that you can adapt to your own environment";

  # Flake inputs
  inputs = {
    git-hooks.url = "github:cachix/git-hooks.nix";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    systems.url = "github:nix-systems/default";
  };

  # Flake outputs
  outputs =
    { self, ... }@inputs:
    let
      stateVersion = 25.11;
      myLib = import ./lib {
        inherit inputs stateVersion;
        inherit (self) outputs;
      };
      nodes = {
        "homeserver2" = {
          hostname = "homeserver2";
        };
      };
    in
    {
      checks = myLib.forEachSystem (system: {
        pre-commit-check = inputs.git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            deadnix.enable = true;
            flake-checker.enable = true;
            nil.enable = true;
            nixfmt-rfc-style.enable = true;
            statix.enable = true;
          };
        };
      });
      formatter = myLib.forEachSystem (
        system:
        let
          pkgs = myLib.getNixpkgs system;
          inherit (self.checks.${system}) pre-commit-check;
          script = ''
            ${pre-commit-check.config.package}/bin/pre-commit run --all-files --config ${pre-commit-check.config.configFile}
          '';
        in
        pkgs.writeShellScriptBin "pre-commit-run" script
      );
      devShells = myLib.forEachSystem (system: {
        default =
          let
            pkgs = myLib.getNixpkgs system;
            inherit (self.checks.${system}) pre-commit-check;
          in
          pkgs.mkShell {
            buildInputs = pre-commit-check.enabledPackages;
            packages = with pkgs; [ ];
            env = { };
            inherit (pre-commit-check) shellHook;
          };
      });
      nixosConfigurations = {
        "homeserver2" = myLib.os.mkOs nodes."homeserver2";
      };
    };
}
