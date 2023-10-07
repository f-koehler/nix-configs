{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # home.username = "fkoehler";
  # home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/fkoehler" else "/home/fkoehler";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    awscli2
    bat
    fish
    # neovim
    nixpkgs-fmt
    zsh
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # It is sometimes useful to fine-tune packages, for example, by applying
    # overrides. You can do that directly here, just don't forget the
    # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # fonts?
    (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Code/configs/nvim";

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fkoehler/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.shellAliases = {
    "cp" = "cp -i";
    "mv" = "mv -i";
    "rm" = "rm -i";
    "cat" = "bat --plain --paging=never";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = if pkgs.stdenv.isDarwin then 12 else 9;
        normal = {
          family = "Hack Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "Hack Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "Hack Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "Hack Nerd Font";
          style = "Bold Italic";
        };
      };
    };
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      style = "compact";
      inline_height = 20;
      show_preview = true;
    };
    flags = [
      "--disable-up-arrow"
    ];
  };
  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
  programs.eza = {
    enable = true;
    enableAliases = true;
  };
  # programs.fzf = {
  #   enable = true;
  #   enableBashIntegration = true;
  #   enableFishIntegration = true;
  #   enableZshIntegration = true;
  #   tmux.enableShellIntegration = true;
  # };
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-dash
      gh-actions-cache
    ];
  };
  programs.git = {
    enable = true;
    userEmail = "me@fkoehler.org";
    userName = "Fabian Köhler";
    signing = {
      key = "C5DC80511469AD81C84E3564D55A35AFB2900A11";
    };
    extraConfig = {
      pull = {
        rebase = "false";
      };
      init = {
        defaultBranch = "main";
      };
      color = {
        ui = "auto";
      };
    };
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "mbp2021" = {
        hostname = "100.101.7.60";
        port = 22;
        user = "fkoehler";
      };
      "vps" = {
        hostname = "100.74.108.18";
        port = 20257;
        user = "fkoehler";
      };
      "osmc" = {
        hostname = "100.82.94.54";
        port = 22;
        user = "osmc";
      };
      "zoq45" = {
        hostname = "100.107.23.113";
        port = 22;
        user = "fkoehler";
      };
    };
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    terminal = "screen-256color";
  };
  # programs.wezterm = lib.mkIf pkgs.stdenv.isLinux {
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm';
      local config = {}
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.audible_bell = "Disabled"
      config.font = wezterm.font('Hack Nerd Font')
      config.font_size = 9.0
      config.hide_tab_bar_if_only_one_tab = true
    
      return config
    '';
  };
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.zellij = {
    enable = true;
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 1000000;
      share = true;
      size = 1000000;
    };
    initExtra = ''
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[3~" delete-char
      bindkey "^[[1;3D" backward-word
      bindkey "^[[1;3C" forward-word
      if [[ "$OSTYPE" == "darwin"* ]]; then
        eval $(/opt/homebrew/bin/brew shellenv )
        export FPATH=\"/opt/homebrew/share/zsh/site-functions:''${FPATH}\"
      fi
      
      export GPG_TTY=$(tty)
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
