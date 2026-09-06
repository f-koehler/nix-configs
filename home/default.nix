{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./accounts.nix
    ./ai.nix
    ./aws.nix
    ./edge.nix
    ./firefox.nix
    ./flatpak.nix
    ./git.nix
    ./kde.nix
    ./linux.nix
    ./sftpman.nix
    ./spack.nix
    ./ssh.nix
    ./tags.nix
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
      pkgs.age
      pkgs.ccache
      pkgs.devenv
      pkgs.glow
      pkgs.just
      pkgs.ncdu
      pkgs.neovim
      pkgs.prek
      pkgs.prettier
      pkgs.sops
      pkgs.ssh-to-age
      pkgs.zotero
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    ];

    pointerCursor = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      dotIcons.enable = true;
      gtk.enable = true;
    };

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      # use system ssh to avoid nix ssh not finding the system ssh-agent
      GIT_SSH = "/usr/bin/ssh";
      CMAKE_C_COMPILER_LAUNCHER = "ccache";
      CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
      VCPKG_ROOT = "${config.home.homeDirectory}/vcpkg";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      CUDA_PATH = "/usr/local/cuda";
      CMAKE_CUDA_COMPILER_LAUNCHER = "ccache";
      CMAKE_TOOLCHAIN_FILE = "${config.home.homeDirectory}/vcpkg/scripts/buildsystems/vcpkg.cmake";
    };
    sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/vcpkg"
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      "/usr/local/cuda/bin"
    ];

    shell = {
      enableNushellIntegration = true;
      enableShellIntegration = true;
    };
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
      package = pkgs.alacritty;
    };
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };
    bash.enable = true;
    bat.enable = true;
    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    eza = {
      enable = true;
      icons = "auto";
    };
    btop.enable = true;
    difftastic = {
      enable = true;
      git = {
        enable = true;
        mode = "difftool";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    direnv-instant.enable = true;
    distrobox = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
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
    fresh-editor = {
      enable = true;
    };
    fzf = {
      enable = true;
      historyWidget.command = "";
      tmux = {
        enableShellIntegration = true;
      };
    };
    gpg = {
      enable = true;
    };
    ghostty = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      systemd = {
        enable = true;
      };
    };
    herdr = {
      enable = true;
      settings = {
        theme = {
          name = "catppuccin";
        };
        ui = {
          show_agent_labels_on_pane_borders = true;
          sound.enabled = false;
          toast.delivery = "herdr";
        };
      };
    };
    keepassxc = {
      enable = true;
      autostart = pkgs.stdenv.hostPlatform.isLinux;
      settings = {
        Browser = {
          Enabled = true;
          UpdateBinaryPath = false;
        };
        GUI = {
          AdvancedSettings = true;
          ApplicationTheme = "dark";
          CompactMode = true;
          HidePasswords = true;
        };
        SSHAgent = {
          Enabled = true;
        };
      };
    };
    lan-mouse = {
      enable = true;
      systemd = pkgs.stdenv.hostPlatform.isLinux;
      # settings = {};
    };
    man = {
      enable = true;
      package = pkgs.man;
      generateCaches = true;
      man-db.enable = true;
    };
    nix-index.enable = true;
    mergiraf.enable = true;
    nushell = {
      enable = true;
      settings = {
        edit_mode = "vi";
        show_banner = false;
      };
      shellAliases = {
        g = "git";
        ll = "ls -l";
      };
    };
    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };
    thunderbird = {
      enable = true;
      package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.thunderbird else pkgs.thunderbird-bin;
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
    zathura.enable = pkgs.stdenv.hostPlatform.isLinux;
    zellij.enable = true;
    zoxide.enable = true;
  };
  services = {
    gpg-agent = {
      enable = true;
      grabKeyboardAndMouse = true;
      pinentry =
        if pkgs.stdenv.hostPlatform.isLinux then
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
  xdg = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    autostart.enable = true;
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "Alacritty.desktop" ];
      };
    };
  };
}
