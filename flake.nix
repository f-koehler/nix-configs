{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

    disko = {
      url = "github:nix-community/disko/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        disko.follows = "disko";
      };
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    flake-utils.url = "github:numtide/flake-utils";
    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = {self, ...} @ inputs: let
    inherit (self) outputs;
    stateVersion = "23.11";
    mylib = import ./lib {inherit inputs outputs stateVersion;};
  in
    {
      homeConfigurations = {
        "fkoehler@fkt14" = mylib.mkHome {
          hostname = "fkt14";
          username = "fkoehler";
        };
        "fkoehler@mbp2021" = mylib.mkHome {
          hostname = "mbp2021";
          username = "fkoehler";
          system = "aarch64-darwin";
        };
      };

      nixosConfigurations."fkt14" = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        system = "x86_64-linux";
        modules = [
          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
            ];
          }
          inputs.sops-nix.nixosModules.sops
          ./nixos/fkt14.nix
        ];
      };
      nixosConfigurations."homeserver" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
            ];
          }
          inputs.sops-nix.nixosModules.sops
          ./nixos/homeserver.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };

      darwinConfigurations."mbp2021" = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          # {
          #   nixpkgs.overlays = [
          #     inputs.nix-vscode-extensions.overlays.default
          #   ];
          # }
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
              alejandra.enable = true;
              deadnix.enable = true;
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
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      }
    );
}
