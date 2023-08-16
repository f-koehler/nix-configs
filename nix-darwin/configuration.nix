{ config, pkgs, ... }: {
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
    nixpkgs-lint
    nixd

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
    brewPrefix = "/opt/homebrew/bin";
    onActivation.cleanup = "zap";
    brews = [
      "java"
    ];
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
      # "microsoft-onenote"
      # "microsoft-outlook"
      "microsoft-excel"
      "microsoft-word"
      "microsoft-powerpoint"
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
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
    ];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}
