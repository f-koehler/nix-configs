{
  inputs,
  outputs,
  stateVersion,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  mkNodeConfig = {
    hostname,
    username,
    system ? "x86_64-linux",
    isWorkstation ? false,
    isTrusted ? false,
    virtualisation ? false,
    containerBackend ? "podman",
  }: {
    inherit inputs outputs stateVersion;
    inherit hostname username system isWorkstation isTrusted containerBackend virtualisation;
  };

  mkNixOSConfig = config: let
    nodeConfig = mkNodeConfig config;
  in {
    specialArgs = {
      inherit inputs outputs stateVersion;
      inherit nodeConfig;
    };
    modules =
      [
        inputs.disko.nixosModules.disko
        inputs.nixos-facter-modules.nixosModules.facter
        inputs.sops-nix.nixosModules.sops
        inputs.catppuccin.nixosModules.catppuccin
        ../nixos

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
      ]
      ++ (lib.optionals nodeConfig.isWorkstation [
        {
          nixpkgs.overlays = [
            inputs.nix-vscode-extensions.overlays.default
          ];
        }
      ]);
  };

  mkNixOS = args:
    lib.nixosSystem (mkNixOSConfig args);

  mkDarwin = {
    hostname,
    username,
    system ? "aarch64-darwin",
    ...
  }:
    inputs.nix-darwin.lib.darwinSystem rec {
      inherit system;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        inputs.mac-app-util.darwinModules.default
        inputs.nix-index-database.darwinModules.nix-index
        (import ../macos {
          inherit pkgs hostname username;
        })
      ];
    };

  mkNixOSImage = {
    system ? "x86_64-linux",
    format,
    ...
  } @ args:
    inputs.nixos-generators.nixosGenerate ({
        inherit system;
        inherit format;
      }
      // (mkNixOSConfig (args // {inherit system;})));

  mkHome = config: let
    nodeConfig = mkNodeConfig config;
  in
    inputs.home-manager.lib.homeManagerConfiguration rec {
      pkgs = inputs.nixpkgs.legacyPackages.${nodeConfig.system};
      extraSpecialArgs = {
        inherit inputs outputs stateVersion;
        inherit (pkgs.stdenv) isLinux isDarwin;
        inherit nodeConfig;
      };
      modules =
        [
          ../home
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.plasma-manager.homeManagerModules.plasma-manager
          inputs.catppuccin.homeManagerModules.catppuccin
          inputs.nixvim.homeManagerModules.nixvim
          inputs.mac-app-util.homeManagerModules.default
        ]
        ++ (lib.optionals (pkgs.stdenv.isLinux && nodeConfig.isWorkstation) [../flatpak.nix]);
    };
in {
  inherit mkNixOS;
  inherit mkNixOSConfig;
  inherit mkNixOSImage;
  inherit mkHome;
  inherit mkDarwin;
  inherit mkNodeConfig;

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
