{
  pkgs,
  hostname,
  username,
  ...
}: {
  users.users.fkoehler.home = "/Users/fkoehler";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  system = {
    defaults = {
      CustomUserPreferences = {
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        "com.apple.controlcenter" = {
          BatteryShowPercentage = true;
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.finder" = {
          _FXSortFoldersFirst = true;
          FXDefaultSearchScope = "SCcf"; # Search current folder by default
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
        };
        "com.apple.SoftwareUpdate" = {
          AutomaticCheckEnabled = true;
          # Check for software updates daily, not just once per week
          ScheduleFrequency = 1;
          # Download newly available updates in background
          AutomaticDownload = 0;
          # Install System data files & security updates
          CriticalUpdateInstall = 1;
        };
        "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
        # Turn on app auto-update
        "com.apple.commerce".AutoUpdate = true;
      };
      dock = {
        autohide = true;
        minimize-to-application = true;
        persistent-apps = [
          "/Users/${username}/Applications/Home Manager Apps/Visual Studio Code.app"
          "/Users/${username}/Applications/Home Manager Apps/Wezterm.app"
          "/Applications/Safari.app"
        ];
        tilesize = 32;
      };
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
        ShowStatusBar = true;
        QuitMenuItem = true;
      };
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false;
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleTemperatureUnit = "Celsius";
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowAMPM = true;
        ShowDate = 1; # 1 = always
        ShowSeconds = false;
      };
      smb.NetBIOSName = hostname;
    };
  };
  networking = {
    hostName = hostname;
    computerName = hostname;
  };
  nix = {
    gc.automatic = true;
    # optimise.automatic = true; # relevant issue: https://github.com/NixOS/nix/issues/7273
    settings = {
      trusted-users = ["root" "${username}"];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  nixpkgs = {
    config.allowUnfree = true;
  };
  security.pam.enableSudoTouchIdAuth = true;
  services = {
    activate-system.enable = true;
    nix-daemon.enable = true;
    tailscale.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      "chatgpt"
      "digikam"
      "docker"
      "nextcloud"
      "obsidian"
      "protonmail-bridge"
      "spotify"
      "telegram"
      "thunderbird"
    ];
    masApps = {
      "Magnet" = 441258766;
      "Infuse • Video Player" = 1136220934;
      "Bitwarden" = 1352778147;
      "AdGuard for Safari" = 1440147259;
      "Wireless@SGx" = 1449928544;
    };
    #   taps = [
    #     "homebrew/cask-fonts"
    #     "homebrew/cask-versions"
    #   ];
  };

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
