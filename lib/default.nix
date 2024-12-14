{
  inputs,
  outputs,
  stateVersion,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  mkNodeConfig = {
    hostname,
    username,
    system ? "x86_64-linux",
    isWorkstation ? false,
    isTrusted ? false,
    virtualisation ? false,
    containerBackend ? "podman",
  }: {
    inherit inputs outputs stateVersion;
    inherit hostname username system isWorkstation isTrusted containerBackend virtualisation;
  };

  mkNixOSConfig = config: let
    nodeConfig = mkNodeConfig config;
  in {
    specialArgs = {
      inherit inputs outputs stateVersion;
      inherit nodeConfig;
    };
    modules = [../nixos];
  };

  mkNixOS = args:
    lib.nixosSystem (mkNixOSConfig args);

  mkDarwin = {
    hostname,
    username,
    system ? "aarch64-darwin",
    ...
  }:
    inputs.nix-darwin.lib.darwinSystem rec {
      specialArgs = {
        inherit inputs outputs stateVersion;
      };
      inherit system;
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      modules = [
        (import ../macos {
          inherit pkgs hostname username inputs outputs;
        })
      ];
    };

  mkNixOSImage = {
    system ? "x86_64-linux",
    format,
    ...
  } @ args:
    inputs.nixos-generators.nixosGenerate ({
        inherit system;
        inherit format;
      }
      // (mkNixOSConfig (args // {inherit system;})));

  mkHome = config: let
    nodeConfig = mkNodeConfig config;
  in
    inputs.home-manager.lib.homeManagerConfiguration rec {
      pkgs = inputs.nixpkgs.legacyPackages.${nodeConfig.system};
      extraSpecialArgs = {
        inherit inputs outputs stateVersion;
        inherit (inputs) self;
        inherit (pkgs.stdenv) isLinux isDarwin;
        inherit nodeConfig;
      };
      modules = [../home];
    };
in {
  inherit mkNixOS;
  inherit mkNixOSConfig;
  inherit mkNixOSImage;
  inherit mkHome;
  inherit mkDarwin;
  inherit mkNodeConfig;

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
