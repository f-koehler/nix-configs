{
  inputs,
  outputs,
  stateVersion,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;
  mkNodeConfig =
    {
      hostname,
      domain ? "corgi-dojo.ts.net",
      username,
      system ? "x86_64-linux",
      isWorkstation ? false,
      isTrusted ? false,
      virtualisation ? false,
      containerBackend ? "podman",
      timeZone ? "Asia/Singapore",
      gpus ? [ ],
      desktops ? [ ],
      fontSize ? 11,
      fontSizeMonospace ? 10,
    }:
    {
      inherit inputs outputs stateVersion;
      inherit
        hostname
        domain
        username
        system
        isWorkstation
        isTrusted
        containerBackend
        virtualisation
        timeZone
        gpus
        desktops
        fontSize
        fontSizeMonospace
        ;
    };

  mkNixOSConfig =
    config:
    let
      nodeConfig = mkNodeConfig config;
    in
    {
      specialArgs = {
        inherit inputs outputs stateVersion;
        inherit nodeConfig;
      };
      modules = [ ../nixos ];
    };

  mkNixOS = args: lib.nixosSystem (mkNixOSConfig args);

  mkDarwin =
    config:
    let
      nodeConfig = mkNodeConfig config;
    in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          stateVersion
          nodeConfig
          ;
      };
      inherit (nodeConfig) system;
      pkgs = inputs.nixpkgs.legacyPackages.${nodeConfig.system};
      modules = [ ../macos ];
    };

  mkHome =
    config:
    let
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
      modules = [ ../home ];
    };

  mkNixOSImage =
    {
      system ? "x86_64-linux",
      format,
      ...
    }@args:
    inputs.nixos-generators.nixosGenerate (
      {
        inherit system;
        inherit format;
      }
      // (mkNixOSConfig (args // { inherit system; }))
    );
in
{
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
