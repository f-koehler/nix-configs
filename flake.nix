{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-hardware .url = "github:NixOS/nixos-hardware/master";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:MIC92/sops-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = {self, ...} @ inputs: let
    inherit (self) outputs;
    stateVersion = "24.05";
    mylib = import ./lib {inherit inputs outputs stateVersion;};
  in
    {
      homeConfigurations = {
        "fkoehler@fkt14" = mylib.mkHome {
          hostname = "fkt14";
          username = "fkoehler";
          isWorkstation = true;
          isTrusted = true;
        };
        "fkoehler@mbp2021" = mylib.mkHome {
          hostname = "mbp2021";
          username = "fkoehler";
          system = "aarch64-darwin";
          isWorkstation = true;
          isTrusted = true;
        };
        "fkoehler@homeserver" = mylib.mkHome {
          hostname = "homeserver";
          username = "fkoehler";
          isWorkstation = false;
          isTrusted = true;
        };
      };

      nixosConfigurations = {
        "fkt14" = mylib.mkNixOS {
          hostname = "fkt14";
          username = "fkoehler";
          isWorkstation = true;
        };
        "homeserver" = mylib.mkNixOS {
          hostname = "homeserver";
          username = "fkoehler";
        };
      };

      darwinConfigurations."mbp2021" = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          inputs.nix-index-database.darwinModules.nix-index
          ./macos/default.nix
        ];
      };

      overlays = import ./overlays {inherit inputs;};
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system: {
        packages = let pkgs = inputs.nixpkgs.legacyPackages.${system}; in import ./packages {inherit pkgs;};
        formatter = inputs.nixpkgs.legacyPackages.${system}.alejandra;
        checks = {
          pre-commit-check = inputs."pre-commit-hooks".lib.${system}.run {
            src = ./.;
            excludes = [
              "secrets/.*"
            ];
            hooks = {
              # nix
              alejandra = {
                enable = true;
                settings.verbosity = "quiet";
              };
              deadnix = {
                enable = true;
                settings.edit = true;
              };
              nil.enable = true;
              statix.enable = true;

              # shell
              shellcheck.enable = true;
              shfmt.enable = true;

              # yaml
              yamllint.enable = true;

              # toml
              taplo.enable = true;

              # other
              prettier.enable = true;
              actionlint.enable = true;
            };
          };
        };
        devShell = inputs.nixpkgs.legacyPackages.${system}.mkShell {
          packages = let pkgs = inputs.nixpkgs.legacyPackages.${system}; in [pkgs.statix];
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      }
    );
}
