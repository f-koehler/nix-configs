{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    deploy-rs.url = "github:serokell/deploy-rs";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    catppuccin.url = "github:catppuccin/nix";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";

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

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ashell = {
      url = "github:MalpenZibo/ashell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    inherit (self) outputs;
    stateVersion = "24.11";
    mylib = import ./lib {inherit inputs outputs stateVersion;};

    config-fkt14 = {
      hostname = "fkt14";
      username = "fkoehler";
      isWorkstation = true;
      isTrusted = true;
      containerBackend = "docker";
      virtualisation = true;
    };
    config-mbp21 = {
      hostname = "mbp21";
      username = "fkoehler";
      system = "aarch64-darwin";
      isWorkstation = true;
      isTrusted = true;
    };
    config-homeserver = {
      hostname = "homeserver";
      username = "fkoehler";
      isWorkstation = false;
      isTrusted = true;
    };
    config-vps = {
      hostname = "vps";
      username = "fkoehler";
      isWorkstation = false;
      isTrusted = true;
    };
  in {
    homeConfigurations = {
      "fkoehler@fkt14" = mylib.mkHome config-fkt14;
      "fkoehler@mbp21" = mylib.mkHome config-mbp21;
      "fkoehler@homeserver" = mylib.mkHome config-homeserver;
      "fkoehler@vps" = mylib.mkHome config-vps;
    };

    nixosConfigurations = {
      "fkt14" = mylib.mkNixOS config-fkt14;
      "homeserver" = mylib.mkNixOS config-homeserver;
      "vps" = mylib.mkNixOS config-vps;
    };

    darwinConfigurations = {
      "mbp21" = mylib.mkDarwin config-mbp21;
    };

    deploy = {
      remoteBuild = true;
      nodes = {
        # vps = {
        #   profiles = {
        #     system = {
        #       path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vps;
        #     };
        #   };
        # };
        mpb21 = {
          profiles = {
            system = {
              user = "fkoehler";
              path = inputs.deploy-rs.lib.aarch64-darwin.activate.darwin self.darwinConfigurations.mbp21;
              hostname = "mbp21";
            };
          };
        };
      };
    };

    # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

    overlays = import ./overlays {inherit inputs;};
    packages = mylib.forAllSystems (system: import ./packages inputs.nixpkgs.legacyPackages.${system});
  };
}
