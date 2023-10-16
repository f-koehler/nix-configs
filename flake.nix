{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nix-darwin, home-manager, nixpkgs, ... }: {
    darwinConfigurations."mbp2021" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.fkoehler = import ./home.nix;
          };
        }
        ./home/default.nix
      ];
    };

    homeConfigurations."fkoehler@fke15" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      modules = [
        ./home.nix
        {
          home = {
            username = "fkoehler";
            homeDirectory = "/home/fkoehler";
          };
        }
        ./home/default.nix
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
        ./home/default.nix
      ];
    };
  };
}
