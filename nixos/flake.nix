{
  outputs = { self, nixpkgs }: {
    nixosConfigurations.fknix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
