{
  description = "Home Configurations";

  inputs = {
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-deskflow = {
      url = "github:deskflow/homebrew-tap";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        cl-nix-lite.inputs = {
          nixpkgs.follows = "nixpkgs";
          systems.follows = "systems";
          treefmt-nix.follows = "mac-app-util/treefmt-nix";
        };
      };
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs.nixpkgs) lib;
      forEachSystem = lib.genAttrs (import inputs.systems);
      overlays = [
        inputs.fenix.overlays.default
      ];
      overlayModule = {
        nixpkgs.overlays = overlays;
      };
      getNixpkgs =
        system:
        import inputs.nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
      commonHomeManagerModules = [
        inputs.catppuccin.homeModules.catppuccin
        inputs.direnv-instant.homeModules.direnv-instant
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
        inputs.nix-index-database.homeModules.default
        inputs.sops-nix.homeManagerModules.sops
        ./home
        ./theme.nix
      ];
      commonNixOsModules = [
        "${inputs.nixos-hardware}/common/pc"
        overlayModule
        ./nixos
        inputs.catppuccin.nixosModules.catppuccin
        inputs.determinate.nixosModules.default
        inputs.disko.nixosModules.disko
      ];
      commonDarwinModules = [
        overlayModule
        inputs.mac-app-util.darwinModules.default
        inputs.nix-homebrew.darwinModules.nix-homebrew
        ./darwin
      ];
      mkNode =
        {
          user,
          system,
          node,
        }:
        let
          isDarwin = lib.hasSuffix "darwin" system;
          platform = {
            nixpkgs.hostPlatform = system;
          };
          specialArgs = { inherit inputs user; };
        in
        {
          homeConfigurations."${user}@${node}" = inputs.home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = { inherit inputs user; };
            pkgs = getNixpkgs system;
            modules =
              commonHomeManagerModules
              ++ [
                {
                  home = {
                    username = user;
                    homeDirectory = (if isDarwin then "/Users" else "/home") + "/${user}";
                  };
                }
              ]
              ++ lib.optional isDarwin inputs.mac-app-util.homeManagerModules.default
              ++ [ ./nodes/${node}/home.nix ];
          };
        }
        // (
          if isDarwin then
            {
              darwinConfigurations.${node} = inputs.nix-darwin.lib.darwinSystem {
                inherit specialArgs;
                modules = [ platform ] ++ commonDarwinModules ++ [ ./nodes/${node}/darwin.nix ];
              };
            }
          else
            {
              nixosConfigurations.${node} = lib.nixosSystem {
                inherit specialArgs;
                modules = [ platform ] ++ commonNixOsModules ++ [ ./nodes/${node}/nixos.nix ];
              };
            }
        );
      nodes = [
        {
          user = "fkoehler";
          system = "x86_64-linux";
          node = "fk-desktop";
        }
        {
          user = "fkoehler";
          system = "x86_64-linux";
          node = "fk-t14";
        }
        {
          user = "fkoehler";
          system = "aarch64-darwin";
          node = "fk-mbp21";
        }
      ];
    in
    lib.foldl' lib.recursiveUpdate { inherit overlays; } (map mkNode nodes)
    // {
      checks = forEachSystem (system: {
        pre-commit-check = inputs.git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # nix
            deadnix.enable = true;
            flake-checker.enable = true;
            nil.enable = true;
            nixfmt.enable = true;
            #statix.enable = true;

            # python
            ruff.enable = true;
            ruff-format.enable = true;

            # JSON
            prettier.enable = true;
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
            packages = [
              inputs.home-manager.packages.${system}.home-manager
              pkgs.nixd
              pkgs.nil
            ]
            ++ (lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
              inputs.nix-darwin.packages.${system}.darwin-rebuild
            ]);
            env = { };
            inherit (pre-commit-check) shellHook;
          };
      });
    };
}
