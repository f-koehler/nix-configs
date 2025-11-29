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
      package = pkgs.gitFull;
      signing = {
        format = "openpgp";
        key = "C5DC80511469AD81C84E3564D55A35AFB2900A11";
        signByDefault = true;
      };
      settings = {
        fetch = {
          all = true;
          prune = true;
          pruneTags = true;
        };
        help.autoCorrect = "prompt";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        user = {
          email = "fabian@fkoehler.me";
          name = "Fabian Koehler";
        };
      };
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
      userSettings = {
        telemetry.metrics = false;
        vim_mode = true;
      };
    };
    zellij.enable = true;
    zoxide.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autocd = true;
      autosuggestion.enable = true;
      history = {
        append = true;
        expireDuplicatesFirst = true;
        extended = true;
        findNoDups = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        save = 100000;
        saveNoDups = true;
        share = true;
        size = 100000;
      };
      historySubstringSearch.enable = true;
      setOptions = [ "NO_BEEP" ];
      syntaxHighlighting.enable = true;
    };
  };
  targets = {
    genericLinux = {
      enable = true;
      gpu.enable = true;
    };
  };
}
