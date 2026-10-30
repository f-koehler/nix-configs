{
  pkgs,
  lib,
  config,
  inputs,
  hasAnyTagOf,
  hasTag,
  ...
}:
let
  workstation = hasAnyTagOf [
    "desktop"
    "laptop"
  ];
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.direnv-instant.homeModules.direnv-instant
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.nix-index-database.homeModules.default
    inputs.sops-nix.homeManagerModules.sops
    ../tags.nix
    ../theme.nix
    ./accounts.nix
    ./aerospace.nix
    ./ai.nix
    ./aws.nix
    ./development
    ./editor-tools.nix
    ./edge.nix
    ./firefox.nix
    ./flatpak.nix
    ./git.nix
    ./keepassxc.nix
    ./neovim.nix
    ./sftpman.nix
    ./spack.nix
    ./ssh.nix
    ./zed-editor.nix
    ./zsh.nix
  ];

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  fonts = {
    fontconfig = {
      enable = true;
    };

  };
  home = {
    stateVersion = "26.11";
    preferXdgDirectories = true;

    file = {
      ".ideavimrc".text = ''
        set visualbell
        set noerrorbells
        Plug 'tpope/vim-commentary'
      '';
    };

    packages = [
      pkgs.scanmem
      pkgs.age
      pkgs.devenv
      pkgs.glow
      pkgs.just
      pkgs.ncdu
      pkgs.nh
      pkgs.nix-tree
      pkgs.pkg-config
      pkgs.prek
      pkgs.prettier
      pkgs.sops
      pkgs.ssh-to-age
    ]
    ++ lib.optionals workstation [
      pkgs.ccache
      pkgs.vcpkg
    ]
    ++ lib.optional (hasTag "personal") pkgs.jellyfin-tui
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      # pkgs.zotero
    ];

    pointerCursor = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && workstation) {
      enable = true;
      dotIcons.enable = true;
      gtk.enable = true;
    };

    sessionVariables = {
      EDITOR = "nvim";
    }
    // lib.optionalAttrs workstation {
      BROWSER = "firefox";
      CMAKE_C_COMPILER_LAUNCHER = "ccache";
      CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
      VCPKG_ROOT = "${pkgs.vcpkg}";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      # gpg-agent only exports this from shell init, GUI apps in the sway session need it too
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh";
    }
    // lib.optionalAttrs (pkgs.stdenv.hostPlatform.isLinux && workstation) {
      CMAKE_CUDA_COMPILER_LAUNCHER = "ccache";
      CMAKE_TOOLCHAIN_FILE = "${pkgs.vcpkg}/share/vcpkg/scripts/buildsystems/vcpkg.cmake";
    };
    sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/vcpkg"
    ];

    shell = {
      enableShellIntegration = true;
    };
  };
  programs = {
    aerc = lib.mkIf workstation {
      enable = true;
      extraConfig = {
        general = {
          unsafe-accounts-conf = true;
        };
      };
    };
    home-manager.enable = true;
    alacritty = lib.mkIf workstation {
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
      enable = pkgs.stdenv.hostPlatform.isLinux && workstation;
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
    ghostty = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && workstation) {
      enable = true;
      systemd = {
        enable = true;
      };
    };
    herdr = {
      enable = true;
      mutableSettings = true;
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
    man = {
      enable = true;
      package = pkgs.man;
      generateCaches = true;
      man-db.enable = true;
    };
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    mergiraf.enable = true;
    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };
    thunderbird = lib.mkIf workstation {
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
    zathura.enable = pkgs.stdenv.hostPlatform.isLinux && workstation;
    zellij.enable = true;
    zoxide.enable = true;
  };
  services = {
    gpg-agent = lib.mkIf workstation {
      enable = true;
      enableSshSupport = true;
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
    # Linux only, the Mac uses the Homebrew cask
    nextcloud-client = {
      enable = pkgs.stdenv.hostPlatform.isLinux && workstation;
      startInBackground = true;
    };
  };
  xdg = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && workstation) {
    enable = true;
    autostart.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "okular.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "image/png" = "gwenview.desktop";
        "message/rfc822" = "userapp-Thunderbird-PIT5X3.desktop";
        "text/csv" = "calc.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/mailto" = "userapp-Thunderbird-PIT5X3.desktop";
        "x-scheme-handler/mid" = "userapp-Thunderbird-PIT5X3.desktop";
        "x-scheme-handler/net.thunderbird" = "userapp-Thunderbird-QCG6X3.desktop";
      };
    };
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "Alacritty.desktop" ];
      };
    };
  };
}
