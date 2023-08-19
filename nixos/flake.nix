{
  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { self, nixpkgs, ... } @ inputs: {
    nixosConfigurations.fknix = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
