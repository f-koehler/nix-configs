{
  pkgs,
  lib,
  inputs,
  outputs,
  username,
  config,
  stateVersion,
  isWorkstation,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
in {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    inputs.sops-nix.homeManagerModules.sops
    ./modules
  ];

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

  sops = {
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
      nh
      age
      bat
      du-dust
      fish
      hexyl
      lunarvim
      pre-commit
      rye
      sops
      zsh
      pandoc
      yt-dlp
      aria
      onefetch
      gdu
      hyperfine
      yq-go
      nix-tree
      ncdu
      htop
      cascadia-code

      # It is sometimes useful to fine-tune packages, for example, by applying
      # overrides. You can do that directly here, just don't forget the
      # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # fonts?
      (pkgs.nerdfonts.override {fonts = ["Hack"];})

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
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

      ".local/share/jellyfinmediaplayer/scripts/mpris.so".source = lib.mkIf (pkgs.stdenv.isLinux && isWorkstation) "${pkgs.mpvScripts.mpris}/share/mpv/scripts/mpris.so";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.shellAliases = {
    "cp" = "cp -i";
    "mv" = "mv -i";
    "rm" = "rm -i";
    "cat" = "bat --style=plain --paging=never";
    "tailscale" = lib.mkIf pkgs.stdenv.isDarwin "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    "open" = lib.mkIf pkgs.stdenv.isLinux "xdg-open";
  };

  programs = {
    bash.enable = true;
    bat.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    password-store.enable = true;
    zellij = {
      enable = true;
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
