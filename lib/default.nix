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
      inherit inputs outputs hostname system username isWorkstation containerBackend;
    };
    modules =
      [
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
        ]
        ++ (lib.optionals (pkgs.stdenv.isLinux && isWorkstation) [../flatpak.nix]);
    };
in {
  inherit mkNixOS;
  inherit mkNixOSConfig;
  inherit mkNixOSImage;
  inherit mkHome;
}
