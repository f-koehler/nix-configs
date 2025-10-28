{
  description = "An empty flake template that you can adapt to your own environment";

  # Flake inputs
  inputs = {
    disko.url = "github:nix-community/disko";
    git-hooks.url = "github:cachix/git-hooks.nix";
    nixos-anywhere.url = "github:nix-community/nixos-anywhere";
    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
    nixos-facter.url = "github:nix-community/nixos-facter";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake outputs
  outputs =
    { self, ... }@inputs:
    let
      stateVersion = "25.11";
      myLib = import ./lib {
        inherit inputs stateVersion;
        inherit (self) outputs;
      };
      nodes = {
        "homeserver-dev" = {
          hostName = "homeserver-dev";
          hostId = "760f3bc8";
          features = {
            audiobookshelf.enable = false;
            navidrome.enable = false;
          };
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
            packages = [
              pkgs.just
              inputs.nixos-anywhere.packages.${system}.nixos-anywhere
              inputs.nixos-facter.packages.${system}.nixos-facter
            ];
            env = { };
            inherit (pre-commit-check) shellHook;
          };
      });
      nixosConfigurations = {
        "homeserver-dev" = myLib.os.mkOs nodes."homeserver-dev";
      };
      packages.x86_64-linux = {
        user-service-proxy = inputs.nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [
            {
              services.tailscale.enable = true;
            }
          ];
          format = "docker";
        };
      };
    };
}
