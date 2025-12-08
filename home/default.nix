{ pkgs, lib, ... }:
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

    file = {
    };

    sessionVariables = {
      GIT_SSH = "/usr/bin/ssh";
    };

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
    mergiraf.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
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
      };
    };
    style.name = "kvantum";
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
