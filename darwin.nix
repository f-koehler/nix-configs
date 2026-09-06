_: {
  # do not manage nix via nix-darwin, clashes with determinate nix
  nix.enable = false;

  networking = {
    hostName = "fk-mbp21";
    localHostName = "fk-mbp21";
    computerName = "Fabian MacBook Pro 21";
  };
  system = {
    primaryUser = "fkoehler";
    startup.chime = false;
    stateVersion = 7;
    defaults = {
      dock = {
        autohide = true;
        largesize = 48;
        magnification = true;
        minimize-to-application = true;
        orientation = "bottom";
        persistent-apps = [
          # TODO(fk): declare persistent apps
        ];
        show-recents = false;
        tilesize = 32;
      };
    };
  };

  services = {
    tailscale.enable = true;
  };

  nix-homebrew = {
    enable = true;
  };

  homebrew = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    brews = [
      # "cmake"
      # "doxygen"
      # "gcc"
      # "immich-cli"
      # "mas"
      # "ninja"
    ];
    casks = [
      # "deskflow-dev"
      # "discord"
      # "drawio"
      # "font-caskaydia-cove-nerd-font"
      # "gimp"
      # "google-chrome"
      # "inkscape"
      # "jetbrains-toolbox"
      # "libreoffice"
      "nextcloud"
      "telegram"
      # "spotify"
      # "steam"
      # "tailscale-app"
      # "vlc"
    ];
    global.autoUpdate = false; # only update on home-manager activation (see below)
    # greedyCasks = true;
    masApps = {
      "Infuse" = 1136220934;
    };
    # taps = [
    #   {
    #     name = "deskflow/tap";
    #     clone_target = "https://github.com/deskflow/homebrew-tap.git";
    #     force_auto_update = true;
    #   }
    # ];
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
