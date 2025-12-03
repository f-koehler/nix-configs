{
  description = "Home Configurations";

  inputs = {
    catppuccin.url = "github:catppuccin/nix";
    git-hooks.url = "github:cachix/git-hooks.nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
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
      homeConfigurations = {
        "fkoehler@desktop" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = getNixpkgs "x86_64-linux";
          modules = [
            ./home
            ./nodes/desktop.nix
            ./theme.nix
            inputs.catppuccin.homeModules.catppuccin
          ];
        };
        "fkoehler@fedora" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = getNixpkgs "x86_64-linux";
          modules = [
            ./home
            ./nodes/fedora.nix
            ./theme.nix
            inputs.catppuccin.homeModules.catppuccin
          ];
        };
      };
      # darwinConfigurations.mbp = inputs.nix-darwin.lib.darwinSystem {
      #   specialArgs = { inherit inputs; };
      #   modules = [
      #     ./darwin.nix
      #     inputs.home-manager.darwinModules.home-manager
      #     {
      #       home-manager = {
      #         useGlobalPkgs = true;
      #         useUserPackages = true;
      #         users.fkoehler = ./home.nix { };
      #       };
      #     }
      #   ];
      # };
      checks = forEachSystem (system: {
        pre-commit-check = inputs.git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # nix
            deadnix.enable = true;
            flake-checker.enable = true;
            nil.enable = true;
            nixfmt-rfc-style.enable = true;
            statix.enable = true;

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
            inherit (self.checks.${system}) pre-commit-check;
          in
          pkgs.mkShell {
            buildInputs = pre-commit-check.enabledPackages;
            packages = [
              inputs.home-manager.packages.${system}.home-manager
            ];
            env = { };
            inherit (pre-commit-check) shellHook;
          };
      });
    };
}
