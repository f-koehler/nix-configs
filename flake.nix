{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-hardware .url = "github:NixOS/nixos-hardware/master";

    catppuccin.url = "github:catppuccin/nix";

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

    plasma-manager = {
      url = "github:pjones/plasma-manager";
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

    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nil.url = "github:oxalica/nil";
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
    };
    config-mbp2021 = {
      hostname = "mbp2021";
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
    config-downloader = {
      hostname = "downloader";
      username = "downloader";
      isWorkstation = false;
      isTrusted = false;
    };
  in {
    homeConfigurations = {
      "fkoehler@fkt14" = mylib.mkHome config-fkt14;
      "fkoehler@mbp2021" = mylib.mkHome config-mbp2021;
      "fkoehler@homeserver" = mylib.mkHome config-homeserver;
    };

    nixosConfigurations = {
      "fkt14" = mylib.mkNixOS config-fkt14;
      "homeserver" = mylib.mkNixOS config-homeserver;
    };

    darwinConfigurations."mbp2021" = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        inputs.nix-index-database.darwinModules.nix-index
        ./macos/default.nix
      ];
    };

    packages.x86_64-linux = {
      downloader-qcow = mylib.mkNixOSImage ({format = "qcow";} // config-downloader);
    };

    overlays = import ./overlays {inherit inputs;};
  };
}
