{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = { nix-darwin, home-manager, nixpkgs, nixgl, ... }: {
    darwinConfigurations."mbp2021" = nix-darwin.lib.darwinSystem {
      modules = [
        ./nix-darwin/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.fkoehler = import ./home.nix;
          };
        }
      ];
    };

    homeConfigurations."fkoehler@fke15" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
      };
      modules = [
        ./home.nix
        {
          home = {
            username = "fkoehler";
            homeDirectory = "/home/fkoehler";
          };
        }
      ];
    };

    homeConfigurations."runner" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      modules = [
        ./home.nix
        {
          home = {
            username = "runner";
            homeDirectory = "/home/runner";
          };
        }
      ];
    };
  };
}
