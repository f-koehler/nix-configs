{
  inputs,
  outputs,
  stateVersion,
  ...
}: {
  mkHome = {
    hostname,
    username,
    system ? "x86_64-linux",
    isWorkstation ? false,
    isTrusted ? false,
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
        ++ (
          # TODO: simplify with lib.optionals
          if (pkgs.stdenv.isLinux && isWorkstation)
          then [
            ../flatpak.nix
          ]
          else []
        );
    };
  mkNixOS = {
    hostname,
    username,
    system ? "x86_64-linux",
    isWorkstation ? false,
    containerBackend ? "podman",
  }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs hostname system username isWorkstation containerBackend;
      };
      modules =
        [
          inputs.sops-nix.nixosModules.sops
          inputs.catppuccin.nixosModules.catppuccin
          ../nixos
        ]
        ++ (
          # TODO: simplify with lib.optionals
          if isWorkstation
          then [
            {
              nixpkgs.overlays = [
                inputs.nix-vscode-extensions.overlays.default
              ];
            }
          ]
          else []
        );
    };
}
