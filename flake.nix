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
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lan-mouse = {
      url = "github:feschber/lan-mouse";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        cl-nix-lite.inputs = {
          nixpkgs.follows = "nixpkgs";
          systems.follows = "systems";
          flake-parts.follows = "flake-parts";
          treefmt-nix.follows = "mac-app-util/treefmt-nix";
        };
      };
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
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
      forEachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
      getNixpkgs =
        system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      homeConfigurations =
        let
          commonHomeManagerModules = [
            inputs.catppuccin.homeModules.catppuccin
            inputs.direnv-instant.homeModules.direnv-instant
            inputs.lan-mouse.homeManagerModules.default
            inputs.nix-index-database.homeModules.default
            inputs.sops-nix.homeManagerModules.sops
            ./home
            ./theme.nix
          ];
        in
        {
          "fkoehler@desktop" =
            let
              system = "x86_64-linux";
            in
            inputs.home-manager.lib.homeManagerConfiguration {
              extraSpecialArgs = { inherit inputs; };
              pkgs = getNixpkgs system;
              modules = commonHomeManagerModules ++ [
                ./nodes/desktop.nix
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
              ];
            };
          "fkoehler@fkt14" =
            let
              system = "x86_64-linux";
            in
            inputs.home-manager.lib.homeManagerConfiguration {
              extraSpecialArgs = { inherit inputs; };
              pkgs = getNixpkgs system;
              modules = commonHomeManagerModules ++ [
                ./nodes/fkt14.nix
                inputs.nix-flatpak.homeManagerModules.nix-flatpak
              ];
            };
          "fkoehler@fk-mbp21" =
            let
              system = "aarch64-darwin";
            in
            inputs.home-manager.lib.homeManagerConfiguration {
              extraSpecialArgs = {
                inherit inputs;
                inherit system;
              };
              pkgs = getNixpkgs system;
              modules = commonHomeManagerModules ++ [
                inputs.mac-app-util.homeManagerModules.default
                ./nodes/fk-mbp21.nix
              ];
            };
        };
      darwinConfigurations.fk-mbp21 = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          inputs.mac-app-util.darwinModules.default
          inputs.nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "fkoehler";
              taps = {
                "homebrew/homebrew-core" = inputs.homebrew-core;
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
              };
              mutableTaps = false;
              trust = {
                formulae = [ ];
                casks = [ ];
                commands = [ ];
                taps = [ ];
              };
            };
          }
          ({ config, ... }: {
            homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
          })
          ./darwin
        ];
      };
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
            inherit (inputs.nixpkgs) lib;
            inherit (self.checks.${system}) pre-commit-check;
          in
          pkgs.mkShell {
            buildInputs = pre-commit-check.enabledPackages;
            packages = [
              inputs.home-manager.packages.${system}.home-manager
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
