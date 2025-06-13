{
  description = "Python tool to acquire a lock file for running a command";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      project = inputs.pyproject-nix.lib.project.loadPyproject {
        projectRoot = ./.;
      };

      forAllSystems = inputs.nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          python = pkgs.python3;
          arg = project.renderers.withPackages { inherit python; };
          pythonEnv = python.withPackages arg;
        in
        {
          default = pkgs.mkShell {
            packages = [
              pythonEnv
              pkgs.sops
              pkgs.age
            ];
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          python = pkgs.python3;
          attrs = project.renderers.buildPythonPackage {
            inherit python;
          };
        in
        {
          default = python.pkgs.buildPythonPackage (
            attrs
            // {
              dependencies = attrs.dependencies ++ [
                pkgs.age
                pkgs.sops
              ];
            }
          );
        }
      );
    };
}
