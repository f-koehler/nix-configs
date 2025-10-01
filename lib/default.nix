{
  inputs,
  outputs,
  stateVersion,
  ...
}:
{
  os = import ./os.nix { inherit inputs outputs stateVersion; };
  home = import ./home.nix { inherit inputs outputs stateVersion; };
  common = import ./common.nix { inherit inputs outputs stateVersion; };
  forEachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
  getNixpkgs =
    system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
}
