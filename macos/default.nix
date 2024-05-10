_: {
  users.users.fkoehler.home = "/Users/fkoehler";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [];

  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation.cleanup = "zap";
    brews = [
      "ffmpeg"
      "java"
      "latexindent"
      "python@3.11"
      "poetry"
    ];
    casks = [
      "bitwarden"
      "docker"
      "discord"
      "drawio"
      "firefox"
      "font-hack-nerd-font"
      "font-cascadia-code-nf"
      "gimp"
      "gitkraken"
      "inkscape"
      "libreoffice"
      "mactex"
      "microsoft-teams"
      "microsoft-excel"
      "microsoft-word"
      "microsoft-powerpoint"
      "miniconda"
      "nextcloud"
      "obsidian"
      "protonmail-bridge"
      "skim"
      "spotify"
      "steam"
      "telegram"
      "threema-beta"
      "thunderbird"
      "transmission"
      "utm"
      "wezterm"
      "whatsapp"
      "superproductivity"
      "tinymediamanager"
      "zoom"
      "zotero"
    ];
    masApps = {
      "Magnet" = 441258766;
      "Tailscale" = 1475387142;
      "Xcode" = 497799835;
      "Microsoft Remote Desktop" = 1295203466;
    };
    taps = [
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
  nixpkgs.hostPlatform = "aarch64-darwin";
}
