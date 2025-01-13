{
  inputs,
  outputs,
  pkgs,
  nodeConfig,
  ...
}:
{
  imports = [
    inputs.mac-app-util.darwinModules.default
    inputs.nix-index-database.darwinModules.nix-index
    ./aerospace.nix
    # ./jankyborders.nix
    ./sketchybar.nix
  ];

  nixpkgs = {
    hostPlatform = "${nodeConfig.system}";
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config.allowUnfree = true;
  };

  users.users.${nodeConfig.username}.home = "/Users/${nodeConfig.username}";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.cmake
    pkgs.gnumake
    pkgs.ninja
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

        com.microsoft.VSCode = {
          ApplePressAndHoldEnabled = false;
        };
      };
      dock = {
        autohide = true;
        minimize-to-application = true;
        persistent-apps = [
          "/Users/${nodeConfig.username}/Applications/Home Manager Apps/Visual Studio Code.app"
          "/Users/${nodeConfig.username}/Applications/Home Manager Apps/Wezterm.app"
          "/Users/${nodeConfig.username}/Applications/Home Manager Apps/Zed.app"
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
      smb.NetBIOSName = nodeConfig.hostname;
    };
  };
  networking = {
    hostName = nodeConfig.hostname;
    computerName = nodeConfig.hostname;
  };
  nix = {
    gc.automatic = true;
    optimise.automatic = true; # relevant issue: https://github.com/NixOS/nix/issues/7273
    settings = {
      trusted-users = [
        "root"
        "${nodeConfig.username}"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };
  security.pam.enableSudoTouchIdAuth = true;
  services = {
    nix-daemon.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      "chatgpt"
      # "digikam" currently using 8.5.0 prebuild for native M1 support and improved ML features
      "docker"
      "gimp"
      "libreoffice"
      "microsoft-teams"
      "nextcloud"
      "obsidian"
      "protonmail-bridge"
      "qgis"
      "spotify"
      "steam"
      "superproductivity"
      "submariner"
      "telegram"
      "transmission"
      "thunderbird"
      "utm"
      "whatsapp"
      "zotero"
    ];
    masApps = {
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
}
