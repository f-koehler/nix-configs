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
      forEachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
      getNixpkgs =
        system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      checks = forEachSystem (system: {
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
      formatter = forEachSystem (
        system:
        let
          pkgs = getNixpkgs system;
          inherit (self.checks.${system}) pre-commit-check;
          script = ''
            ${pre-commit-check.config.package}/bin/pre-commit run --all-files --config ${pre-commit-check.config.configFile}
          '';
        in
        pkgs.writeShellScriptBin "pre-commit-run" script
      );
      devShells = forEachSystem (system: {
        default =
          let
            pkgs = getNixpkgs system;
            inherit (self.checks.${system}) pre-commit-check;
          in
          pkgs.mkShell {
            buildInputs = pre-commit-check.enabledPackages;
            packages = with pkgs; [ ];
            env = { };
            inherit (pre-commit-check) shellHook;
          };
      });
    };
}
