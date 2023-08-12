{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ansible
    ansible-doctor
    ansible-language-server
    ansible-later
    ansible-lint

    clang-tools
    cmake
    cppcheck
    gcc
    gnumake
    lldb

    nodejs
    yarn

    nixpkgs-fmt

    bat
    direnv
    exa
    fzf
    gh
    git
    gnupg
    htop
    jq
    neovim
    qpdf
    rsync
    starship
    tmux
    wget
    zellij
    zoxide
    zsh
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      "bitwarden"
      "brave-browser"
      "docker"
      "font-hack-nerd-font"
      "gimp"
      "inkscape"
      "libreoffice"
      "mactex"
      "microsoft-teams"
      "nextcloud"
      "obsidian"
      "protonmail-bridge"
      "skim"
      "spotify"
      "steam"
      "telegram"
      "thunderbird"
      "utm"
      "visual-studio-code"
      "warp"
      "whatsapp"
      "zoom"
      "zotero"
    ];
    masApps = {
      "Magnet" = 441258766;
      "Tailscale" = 1475387142;
      "Xcode" = 497799835;
    };
    taps = [
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
    ];
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
