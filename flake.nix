{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

    disko = {
      url = "github:nix-community/disko/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        disko.follows = "disko";
      };
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    hyprland.url = "github:hyprwm/Hyprland";
    nixgl.url = "github:guibou/nixGL";

    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { nix-darwin, home-manager, nix-index-database, nixpkgs, nix-vscode-extensions, hyprland, nixgl, hy3, ... }: {
    darwinConfigurations."mac_arm64" = nix-darwin.lib.darwinSystem {
      modules = [
        {
          nixpkgs.overlays = [
            nix-vscode-extensions.overlays.default
          ];
        }
        nix-index-database.darwinModules.nix-index
        ./macos/default.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.fkoehler = import ./home/default.nix;
          };
        }
      ];
    };

    homeConfigurations = {
      "linux_x64" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        modules = [
          {
            nixpkgs.overlays = [
              nix-vscode-extensions.overlays.default
              nixgl.overlay
            ];
          }
          nix-index-database.hmModules.nix-index
          hyprland.homeManagerModules.default
          ./home/default.nix
          {
            home = {
              username = "fkoehler";
              homeDirectory = "/home/fkoehler";
            };
          }
          {
            wayland.windowManager.hyprland = {
              enable = true;
              plugins = [
                hy3.packages.x86_64-linux.hy3
              ];
            };
          }
        ];
      };
      "gha" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        modules = [
          nix-index-database.hmModules.nix-index
          ./home/default.nix
          {
            home = {
              username = "runner";
              homeDirectory = "/home/runner";
            };
          }
        ];
      };
    };
  };
}
