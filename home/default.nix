{
  pkgs,
  lib,
  inputs,
  outputs,
  username,
  config,
  stateVersion,
  isWorkstation,
  isTrusted,
  isLinux,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  imports =
    [
      inputs.nix-index-database.hmModules.nix-index
      inputs.sops-nix.homeManagerModules.sops
      ./common
    ]
    ++ lib.optional isWorkstation ./workstation;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    pointerCursor = lib.mkIf (!isDarwin) {
      enable = true;
      accent = "mauve";
      flavor = "mocha";
    };
  };

  nixpkgs = {
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
      outputs.overlays.additions
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    package = pkgs.nix;
  };

  sops = lib.mkIf isTrusted {
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      generateKey = false;
    };
    defaultSopsFile = ../secrets/home.yaml;
  };

  fonts.fontconfig.enable = true;
  home = {
    inherit stateVersion;
    inherit username;
    homeDirectory =
      if isDarwin
      then "/Users/${username}"
      else "/home/${username}";

    packages = with pkgs; [
      # awscli2
      # neovim
      pkgs.nh
      pkgs.git
      pkgs.age
      pkgs.bat
      pkgs.du-dust
      pkgs.fish
      pkgs.jq
      pkgs.hexyl
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
      pkgs.nix-tree
      pkgs.ncdu
      pkgs.htop
      pkgs.cascadia-code
      pkgs.devenv
      pkgs.fd
      pkgs.comma
      pkgs.typst
      pkgs.nerd-fonts.hack

      pkgs.nil
      inputs.alejandra.defaultPackage.${system}

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

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
      // lib.mkIf (isWorkstation && isLinux) {
        ".local/share/jellyfinmediaplayer/scripts/mpris.so".source = lib.mkIf (isLinux && isWorkstation) "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";
      };
  };

  programs = {
    bash.enable = true;
    bat.enable = true;
    fd.enable = true;
    password-store.enable = true;

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
