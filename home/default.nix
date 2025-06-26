{
  pkgs,
  lib,
  inputs,
  outputs,
  stateVersion,
  isLinux,
  nodeConfig,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin;
in
{
  imports = [
    inputs.stylix.homeModules.stylix
    inputs.mac-app-util.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index
    inputs.nixvim.homeManagerModules.nixvim
    inputs.plasma-manager.homeManagerModules.plasma-manager
    inputs.sops-nix.homeManagerModules.sops
    ../stylix.nix
    ./common
    ./secrets.nix
  ] ++ lib.optional nodeConfig.isWorkstation ./workstation;

  nixpkgs = {
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config.allowUnfree = true;
  };


  home = {
    inherit stateVersion;
    inherit (nodeConfig) username;
    homeDirectory =
      if isDarwin then "/Users/${nodeConfig.username}" else "/home/${nodeConfig.username}";

    packages = [
      pkgs.git
      pkgs.age
      pkgs.bat
      pkgs.du-dust
      pkgs.fish
      pkgs.jq
      pkgs.lunarvim
      pkgs.pre-commit
      pkgs.rye
      pkgs.sops
      pkgs.zsh
      pkgs.pandoc
      pkgs.aria
      pkgs.onefetch
      pkgs.gdu
      pkgs.hyperfine
      pkgs.yq-go
      pkgs.ncdu
      pkgs.htop
      pkgs.cascadia-code
      pkgs.noto-fonts
      pkgs.fd
      pkgs.typst
    ] ++ lib.optionals isLinux [ pkgs.isd ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file =
      {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
      }
      // lib.mkIf (nodeConfig.isWorkstation && isLinux) {
        ".local/share/jellyfinmediaplayer/scripts/mpris.so".source = lib.mkIf (
          isLinux && nodeConfig.isWorkstation
        ) "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";
      };
  };

  programs = {
    bash.enable = true;
    bat.enable = true;
    fd.enable = true;
    password-store.enable = true;

    man.generateCaches = true;

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
