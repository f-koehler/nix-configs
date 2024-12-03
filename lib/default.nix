{
  inputs,
  outputs,
  stateVersion,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  mkNixOSConfig = {
    hostname,
    username,
    system ? "x86_64-linux",
    isWorkstation ? false,
    containerBackend ? "podman",
    ...
  }: {
    specialArgs = {
      inherit inputs outputs hostname system username isWorkstation containerBackend stateVersion;
    };
    modules =
      [
        inputs.disko.nixosModules.disko
        inputs.nixos-facter-modules.nixosModules.facter
        inputs.sops-nix.nixosModules.sops
        inputs.catppuccin.nixosModules.catppuccin
        ../nixos
      ]
      ++ (lib.optionals isWorkstation [
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

  mkHome = {
    hostname,
    username,
    system ? "x86_64-linux",
    isWorkstation ? false,
    isTrusted ? false,
    ...
  }:
    inputs.home-manager.lib.homeManagerConfiguration rec {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs outputs hostname system username isWorkstation isTrusted stateVersion;
        inherit (pkgs.stdenv) isLinux isDarwin;
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
        ++ (lib.optionals (pkgs.stdenv.isLinux && isWorkstation) [../flatpak.nix]);
    };
in {
  inherit mkNixOS;
  inherit mkNixOSConfig;
  inherit mkNixOSImage;
  inherit mkHome;
  inherit mkDarwin;
}
