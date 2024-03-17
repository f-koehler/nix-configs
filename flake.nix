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
  };

  outputs = {self, ...} @ inputs: let
    # inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = inputs.nixpkgs.lib.genAttrs systems;
  in
    {
      nixosConfigurations."mediapi" = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ./nixos/mediapi.nix
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
      nixosConfigurations."fkt14" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
            ];
          }
          inputs.sops-nix.nixosModules.sops
          ./nixos/fkt14.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.fkoehler = import ./home;
            };
          }
        ];
      };
      nixosConfigurations."homeserver" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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

      darwinConfigurations."mac_arm64" = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
            ];
          }
          inputs.nix-index-database.darwinModules.nix-index
          ./macos/default.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.fkoehler = import ./home/default.nix;
            };
          }
        ];
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system: {
        formatter = forAllSystems (system: inputs.nixpkgs.legacyPackages.${system}.alejandra);
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
