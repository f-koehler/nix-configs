{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:MIC92/sops-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nix-darwin, home-manager, nix-index-database, nixpkgs, ... }: {
    darwinConfigurations."mbp2021" = nix-darwin.lib.darwinSystem {
      modules = [
        nix-index-database.darwinModules.nix-index
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
        nix-index-database.hmModules.nix-index
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
        nix-index-database.hmModules.nix-index
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
