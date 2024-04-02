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
  }:
    inputs.home-manager.lib.homeManagerConfiguration rec {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs outputs hostname system username stateVersion;
      };
      modules =
        [../home]
        ++ (
          if pkgs.stdenv.isLinux
          then [inputs.nix-flatpak.homeManagerModules.nix-flatpak ../flatpak.nix]
          else []
        );
    };
}
