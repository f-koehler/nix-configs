{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./accounts.nix
    ./firefox.nix
    ./git.nix
    ./zed-editor.nix
    ./zsh.nix
  ];

  fonts = {
    fontconfig = {
      enable = true;
    };
  };
  home = {
    stateVersion = "26.05";
    preferXdgDirectories = true;

    file = {
      ".ideavimrc".text = ''
        set visualbell
        set noerrorbells
        Plug 'tpope/vim-commentary'
      '';
    };

    packages = [
      pkgs.devenv
      pkgs.ncdu
      pkgs.jellyfin-tui
    ];

    sessionVariables = {
      GIT_SSH = "/usr/bin/ssh";
      VCPKG_ROOT = "${config.home.homeDirectory}/vcpkg";
    };
    sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
    ];

    shell.enableShellIntegration = true;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
  };
  programs = {
    home-manager.enable = true;
    alacritty = {
      enable = true;
      settings = {
        env = {
          TERM = "xterm-256color";
        };
      };
    };
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };
    awscli = {
      enable = true;
    };
    bash.enable = true;
    bat.enable = true;
    eza = {
      enable = true;
      icons = "auto";
    };
    btop.enable = true;
    difftastic = {
      enable = true;
      git = {
        enable = true;
        diffToolMode = true;
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fish = {
      enable = true;
      generateCompletions = true;
      functions = {
        fish_user_key_bindings = {
          body = ''
            fish_vi_key_bindings --no-erase insert
          '';
        };
      };
    };
    fzf = {
      enable = true;
      tmux = {
        enableShellIntegration = true;
      };
    };
    gh = {
      enable = true;
    };
    gpg = {
      enable = true;
    };
    lazygit.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    mergiraf.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
        "scbd1" = {
          hostname = "10.1.128.104";
          user = "scbd1";
        };
        "scbd2" = {
          hostname = "10.1.128.103";
          user = "scbd2";
        };
        "scbd3" = {
          hostname = "10.1.128.107";
          user = "scbd3";
        };
        "scbd4" = {
          hostname = "10.1.128.102";
          user = "scbd4";
        };
        "dnsmasq" = {
          hostname = "10.1.3.1";
          user = "root";
        };
        "pve-beowulf-0" = {
          hostname = "10.1.206.113";
          user = "root";
        };
        "pve-beowulf-1" = {
          hostname = "10.1.142.246";
          user = "root";
        };
        "fk-gha-runner-x64-005" = {
          hostname = "10.1.218.102";
          user = "fkoehler";
        };
        "fk-gha-runner-x64-006" = {
          hostname = "10.1.255.49";
          user = "fkoehler";
        };
        "fk-gha-runner-x64-007" = {
          hostname = "10.1.242.35";
          user = "fkoehler";
        };
      };
    };
    starship.enable = true;
    thunderbird = {
      enable = true;
      package = if pkgs.stdenv.isLinux then pkgs.thunderbird else pkgs.thunderbird-bin;
      profiles.default = {
        isDefault = true;
      };
    };
    tmux = {
      enable = true;
      clock24 = true;
      mouse = true;
      focusEvents = true;
      keyMode = "vi";
    };
    yazi.enable = true;
    zathura.enable = true;
    zellij.enable = true;
    zoxide.enable = true;
  };
  qt = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    kde.settings = {
      kcminputrc = {
        Mouse = {
          cursorTheme = "catppuccin-mocha-mauve-cursors";
        };
      };
      kdeglobals = {
        Icons = {
          Theme = "Papirus-Dark";
        };
        KDE = {
          AnimationDurationFactor = 0;
          LookAndFeelPackage = "Catppuccin-Mocha-Mauve";
          widgetStyle = "Breeze";
        };
        Sounds = {
          Enable = false;
        };
      };
      kglobalshortcutsrc = {
        ksmserver = {
          "Lock Session" = "Screensaver,Meta+L\tScreensaver,Lock Session";
        };
        kwin = {
          "Switch to Desktop 1" = "Meta+1,Ctrl+F1,Switch to Desktop 1";
          "Switch to Desktop 2" = "Meta+2,Ctrl+F2,Switch to Desktop 2";
          "Switch to Desktop 3" = "Meta+3,Ctrl+F3,Switch to Desktop 3";
          "Switch to Desktop 4" = "Meta+4,Ctrl+F4,Switch to Desktop 4";
          "Switch to Desktop 5" = "Meta+5,,Switch to Desktop 5";
          "Switch to Desktop 6" = "Meta+6,,Switch to Desktop 6";
          "Switch to Desktop 7" = "Meta+7,,Switch to Desktop 7";
          "Switch to Desktop 8" = "Meta+8,,Switch to Desktop 8";
          "Switch to Desktop 9" = "Meta+9,,Switch to Desktop 9";
          "Switch to Desktop 10" = "Meta+0,,Switch to Desktop 10";
          "Window to Desktop 1" = "Meta+!,,Window to Desktop 1";
          "Window to Desktop 2" = "Meta+@,,Window to Desktop 2";
          "Window to Desktop 3" = "Meta+#,,Window to Desktop 3";
          "Window to Desktop 4" = "Meta+$,,Window to Desktop 4";
          "Window to Desktop 5" = "Meta+%,,Window to Desktop 5";
          "Window to Desktop 6" = "Meta+^,,Window to Desktop 6";
          "Window to Desktop 7" = "Meta+&,,Window to Desktop 7";
          "Window to Desktop 8" = "Meta+*,,Window to Desktop 8";
          "Window to Desktop 9" = "Meta+(,,Window to Desktop 9";
          "Show Desktop" = "none,Meta+D,Peek at Desktop";
          "Window Fullscreen" = "Meta+F,,Make Window Fullscreen";
          "KrohnkiteFocusDown" = "Meta+J,none,Krohnkite: Focus Down";
          "KrohnkiteFocusLeft" = "Meta+H,none,Krohnkite: Focus Left";
          "KrohnkiteFocusNext" = "Meta+.,none,Krohnkite: Focus Next";
          "KrohnkiteFocusPrev" = "Meta+\\,,none,Krohnkite: Focus Previous";
          "KrohnkiteFocusRight" = "Meta+L,none,Krohnkite: Focus Right";
          "KrohnkiteFocusUp" = "Meta+K,none,Krohnkite: Focus Up";
          "KrohnkiteMonocleLayout" = "Meta+M,none,Krohnkite: Monocle Layout";
          "KrohnkiteSetMaster" = "Meta+Shift+M,none,Krohnkite: Set master";
          "KrohnkiteShiftDown" = "Meta+Shift+J,none,Krohnkite: Move Down/Next";
          "KrohnkiteShiftLeft" = "Meta+Shift+H,none,Krohnkite: Move Left";
          "KrohnkiteShiftRight" = "Meta+Shift+L,none,Krohnkite: Move Right";
          "KrohnkiteShiftUp" = "Meta+Shift+K,none,Krohnkite: Move Up/Prev";
        };

        plasmashell = {
          "activate task manager entry 1" = "none,Meta+1,Activate Task Manager Entry 1";
          "activate task manager entry 10" = "none,,Activate Task Manager Entry 10";
          "activate task manager entry 2" = "none,Meta+2,Activate Task Manager Entry 2";
          "activate task manager entry 3" = "none,Meta+3,Activate Task Manager Entry 3";
          "activate task manager entry 4" = "none,Meta+4,Activate Task Manager Entry 4";
          "activate task manager entry 5" = "none,Meta+5,Activate Task Manager Entry 5";
          "activate task manager entry 6" = "none,Meta+6,Activate Task Manager Entry 6";
          "activate task manager entry 7" = "none,Meta+7,Activate Task Manager Entry 7";
          "activate task manager entry 8" = "none,Meta+8,Activate Task Manager Entry 8";
          "activate task manager entry 9" = "none,Meta+9,Activate Task Manager Entry 9";
        };

        services = {
          "Alacritty.desktop" = {
            New = "Meta+Return";
          };
          "org.kde.krunner.desktop" = {
            _launch = "Meta+D\tSearch";
          };
        };
      };
      powerdevilrc = {
        AC = {
          Performance = {
            PowerProfile = "performance";
          };
          SuspendAndShutdown = {
            AutoSuspendAction = 0;
          };
        };
        Battery = {
          Performance = {
            PowerProfile = "balanced";
          };
        };
        LowBattery = {
          Performance = {
            PowerProfile = "power-saver";
          };
        };
      };
      dolphinrc = {
        General = {
          EditableUrl = true;
          ShowFullPath = true;
          ShowStatusBar = "FullWidth";
          ShowZoomSlider = true;
        };
      };
    };
  };
  services = {
    gpg-agent = {
      enable = true;
      grabKeyboardAndMouse = true;
      pinentry =
        if pkgs.stdenv.isLinux then
          {
            package = pkgs.pinentry-qt;
            program = "pinentry-qt";
          }
        else
          {
            package = pkgs.pinentry_mac;
            program = "pinentry-mac";
          };
    };
  };
  xdg = {
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "Alacritty.desktop" ];
      };
    };
  };
}
