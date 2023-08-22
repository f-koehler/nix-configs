{
  description = "Home Manager configuration of fkoehler";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    homeConfigurations."fkoehler@mbp2021" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
      };
      modules = [ ./home.nix ];
    };
    homeConfigurations."fkoehler@fke15" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      modules = [ ./home.nix ];
    };
    homeConfigurations."runner" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      modules = [ ./home.nix ];
    };
  };
}
