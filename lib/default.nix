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
  }:
    inputs.home-manager.lib.homeManagerConfiguration rec {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs outputs hostname system username isWorkstation stateVersion;
      };
      modules =
        [../home]
        ++ (
          if (pkgs.stdenv.isLinux && isWorkstation)
          then [
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            inputs.plasma-manager.homeManagerModules.plasma-manager
            ../flatpak.nix
          ]
          else []
        );
    };
}
