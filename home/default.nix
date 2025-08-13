{
  pkgs,
  lib,
  inputs,
  outputs,
  stateVersion,
  nodeConfig,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.stylix.homeModules.stylix
    inputs.mac-app-util.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.sops-nix.homeManagerModules.sops
    ../stylix.nix
    ./common
    ./secrets.nix
  ]
  ++ lib.optional nodeConfig.isWorkstation ./workstation;

  nixpkgs = {
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config.allowUnfree = true;
  };

  stylix.targets.nixos-icons.enable = true;
  catppuccin = {
    enable = false;
    flavor = "mocha";
    accent = "mauve";
  };

  home = {
    inherit stateVersion;
    inherit (nodeConfig) username;
    homeDirectory =
      if isDarwin then "/Users/${nodeConfig.username}" else "/home/${nodeConfig.username}";

    packages = [
      pkgs.age
      pkgs.aria
      pkgs.cascadia-code
      pkgs.fd
      pkgs.hyperfine
      pkgs.jq
      pkgs.ncdu
      pkgs.noto-fonts
      pkgs.pandoc
      pkgs.pre-commit
      pkgs.sops
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };
  };

  programs = {
    bash.enable = true;
    bat.enable = true;
    fd.enable = true;
    home-manager.enable = true;
    htop.enable = true;
    man.generateCaches = true;
    password-store.enable = true;
  };
}
