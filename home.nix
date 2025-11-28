{ pkgs, ... }:
{
  fonts = {
    fontconfig = {
      enable = true;
    };
  };
  home = {
    username = "fkoehler";
    homeDirectory = "/home/fkoehler";

    stateVersion = "25.11";

    packages = [
      pkgs.cascadia-code
      pkgs.noto-fonts
      pkgs.noto-fonts-color-emoji
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
    ];

    file = {
    };

    sessionVariables = {
    };

    shell.enableShellIntegration = true;
  };

  programs = {
    home-manager.enable = true;
    alacritty = {
      enable = true;
      settings = {
        general = {
          env = "xterm-256color";
        };
      };
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
    git = {
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
    tmux = {
      enable = true;
      clock24 = true;
      mouse = true;
      focusEvents = true;
      keyMode = "vi";
    };
    yazi.enable = true;
    zathura.enable = true;
    zed-editor = {
      enable = true;
      installRemoteServer = true;
      extensions = [
        "docker-compose"
        "dockerfile"
        "env"
        "html"
        "make"
        "neocmake"
        "nix"
        "toml"
      ];
    };
    zellij.enable = true;
    zoxide.enable = true;
    zsh.enable = true;
  };
  targets = {
    genericLinux = {
      enable = true;
      gpu.enable = true;
    };
  };
}
