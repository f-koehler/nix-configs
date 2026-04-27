{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./accounts.nix
    ./firefox.nix
    ./git.nix
    ./kde.nix
    ./linux.nix
    ./sftpman.nix
    ./ssh.nix
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
      pkgs.glow
      pkgs.neovim
      pkgs.prettier
    ];

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      GIT_SSH = "/usr/bin/ssh";
      VCPKG_ROOT = "${config.home.homeDirectory}/vcpkg";
      CUDA_PATH = "/usr/local/cuda";
    };
    sessionPath = [
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/.local/bin"
      "/usr/local/cuda/bin/"
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
    man = {
      enable = true;
      generateCaches = true;
    };
    mergiraf.enable = true;
    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];
    };
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
