{
  outputs,
  pkgs,
  hostname,
  username,
  ...
}: {
  users.users.fkoehler.home = "/Users/fkoehler";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    cmake
    gnumake
    ninja
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
          "/Users/${username}/Applications/Home Manager Apps/Visual Studio Code.app"
          "/Users/${username}/Applications/Home Manager Apps/Wezterm.app"
          "/Users/${username}/Applications/Home Manager Apps/Zed.app"
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
    optimise.automatic = true; # relevant issue: https://github.com/NixOS/nix/issues/7273
    settings = {
      trusted-users = ["root" "${username}"];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config.allowUnfree = true;
  };
  security.pam.enableSudoTouchIdAuth = true;
  services = {
    nix-daemon.enable = true;
    aerospace = {
      enable = true;
      settings = {
        after-startup-command = ["exec-and-forget sketchybar"];

        # TODO(fk): disable the next two settings and rexplore the recommendation from the aerospace warning
        enable-normalization-flatten-containers = false;
        enable-normalization-opposite-orientation-for-nested-containers = false;

        exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          "sketchybar --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
        ];
        on-focused-monitor-changed = [
          "move-mouse monitor-lazy-center"
        ];
        mode = {
          main.binding = {
            # Move focus
            alt-h = "focus --boundaries-action wrap-around-the-workspace left";
            alt-j = "focus --boundaries-action wrap-around-the-workspace down";
            alt-k = "focus --boundaries-action wrap-around-the-workspace up";
            alt-l = "focus --boundaries-action wrap-around-the-workspace right";
            # alt-left = "focus --boundaries-action wrap-around-the-workspace left";
            # alt-down = "focus --boundaries-action wrap-around-the-workspace down";
            # alt-up = "focus --boundaries-action wrap-around-the-workspace up";
            # alt-right = "focus --boundaries-action wrap-around-the-workspace right";

            # Move window
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";
            # alt-shift-left = "move left";
            # alt-shift-down = "move down";
            # alt-shift-up = "move up";
            # alt-shift-right = "move right";

            # Change layout
            alt-g = "split horizontal";
            alt-v = "split vertical";
            alt-f = "fullscreen";
            alt-s = "layout v_accordion";
            alt-w = "layout h_accordion";
            alt-e = "layout tiles horizontal vertical";
            alt-shift-space = "layout floating tiling";

            # Change workspace
            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";
            alt-0 = "workspace 10";

            # Move window to workspace
            alt-shift-1 = "move-node-to-workspace 1";
            alt-shift-2 = "move-node-to-workspace 2";
            alt-shift-3 = "move-node-to-workspace 3";
            alt-shift-4 = "move-node-to-workspace 4";
            alt-shift-5 = "move-node-to-workspace 5";
            alt-shift-6 = "move-node-to-workspace 6";
            alt-shift-7 = "move-node-to-workspace 7";
            alt-shift-8 = "move-node-to-workspace 8";
            alt-shift-9 = "move-node-to-workspace 9";
            alt-shift-0 = "move-node-to-workspace 10";

            alt-shift-c = "reload-config";
            alt-r = "mode resize";
          };
          resize.binding = {
            h = "resize width -50";
            j = "resize height +50";
            k = "resize height -50";
            l = "resize width +50";
            left = "resize width -50";
            down = "resize height +50";
            up = "resize height -50";
            right = "resize width +50";
            enter = "mode main";
            esc = "mode main";
          };
        };
      };
    };
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
