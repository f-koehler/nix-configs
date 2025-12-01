{ pkgs, ... }:
{
  accounts = {
    calendar.accounts."fastmail" = {
      primary = true;
      remote = {
        type = "caldav";
        url = "https://caldav.fastmail.com/";
        userName = "fabiankoehler@fastmail.com";
        thunderbird.enable = true;
      };
    };
    contact.accounts."fastmail" = {
      remote = {
        type = "carddav";
        url = "https://carddav.fastmail.com/";
        userName = "fabiankoehler@fastmail.com";
        thunderbird.enable = true;
      };
    };
    email.accounts = {
      "fastmail" = {
        address = "fabian@fkoehler.me";
        primary = true;
        realName = "Fabian Koehler";
        userName = "fabiankoehler@fastmail.com";
        flavor = "fastmail.com";
        aerc.enable = true;
        thunderbird = {
          enable = true;
        };
      };
      "speqtral" = {
        address = "fabian@speqtral.space";
        realName = "Fabian Koehler";
        flavor = "outlook.office365.com";
        thunderbird = {
          enable = true;
          settings = id: {
            "mail.server.server_${id}.authMethod" = 10;
            "mail.server.smtpserver_${id}.authMethod" = 3;
          };
          messageFilters = [
            {
              name = "Move redmine messages";
              enabled = true;
              type = "17";
              action = "Move to folder";
              actionValue = "imap://fabian%40speqtral.space@outlook.office365.com/INBOX/Redmine";
              condition = "AND (from,is,redmine-noreply@speqtranet.com)";
            }
          ];
        };
      };
    };
  };
  fonts = {
    fontconfig = {
      enable = true;
    };
  };
  home = {
    username = "fkoehler";
    homeDirectory = "/home/fkoehler";

    stateVersion = "26.05";

    file = {
    };

    sessionVariables = {
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
    firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;
        extensions.force = true;
        settings = {
          "browser.compactmode.show" = true;
          "browser.uidensity" = 1;
          "sidebar.verticalTabs" = true;
          "browser.tabs.tabmanager.enabled" = false;
          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              widget-overflow-fixed-list = [ ];
              unified-extensions-area = [
                "ublock0_raymondhill_net-browser-action"
                "firefoxcolor_mozilla_com-browser-action"
              ];
              nav-bar = [
                "sidebar-button"
                "customizableui-special-spring1"
                "back-button"
                "stop-reload-button"
                "vertical-spacer"
                "forward-button"
                "urlbar-container"
                "downloads-button"
                "addon_karakeep_app-browser-action"
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
                "zotero_chnm_gmu_edu-browser-action"
                "unified-extensions-button"
                "customizableui-special-spring3"
              ];
              toolbar-menubar = [ "menubar-items" ];
              TabsToolbar = [ ];
              vertical-tabs = [ "tabbrowser-tabs" ];
              PersonalToolbar = [ "personal-bookmarks" ];
            };

            seen = [
              "addon_karakeep_app-browser-action"
              "ublock0_raymondhill_net-browser-action"
              "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
              "zotero_chnm_gmu_edu-browser-action"
              "developer-button"
              "screenshot-button"
              "firefoxcolor_mozilla_com-browser-action"
            ];

            dirtyAreaCache = [
              "unified-extensions-area"
              "nav-bar"
              "toolbar-menubar"
              "TabsToolbar"
              "vertical-tabs"
            ];

            currentVersion = 23;
            newElementCount = 1;
          };
        };
        bookmarks.settings = {
          name = "SpeQtral";
          toolbar = true;
          bookmarks = [
            {
              name = "Redmine Agile";
              url = "http://10.1.5.5:3000/agile/board?set_filter=1&f%5B%5D=assigned_to_id&op%5Bassigned_to_id%5D=%3D&v%5Bassigned_to_id%5D%5B%5D=me&f%5B%5D=status_id&op%5Bstatus_id%5D=%3D&f_status%5B%5D=1&f_status%5B%5D=7&f_status%5B%5D=2&f_status%5B%5D=4&f_status%5B%5D=8&f_status%5B%5D=10&f_status%5B%5D=9&c%5B%5D=tracker&c%5B%5D=estimated_hours&c%5B%5D=spent_hours&c%5B%5D=done_ratio&c%5B%5D=parent&c%5B%5D=assigned_to&c%5B%5D=cf_4&c%5B%5D=cf_3";
            }
          ];
        };
      };
      policies = {
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            default_area = "menupanel";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            default_area = "menupanel";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = false;
          };
          "zotero@chnm.gmu.edu" = {
            default_area = "menupanel";
            install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
            installation_mode = "force_installed";
            private_browsing = false;
          };
          "addon@karakeep.app" = {
            default_area = "menupanel";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/karakeep/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = false;
          };
          "FirefoxColor@mozilla.com" = {
            default_area = "menupanel";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-color/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = false;
          };
        };
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
      gpu = {
        enable = true;
        nvidia = {
          enable = true;
          sha256 = "sha256-2cboGIZy8+t03QTPpp3VhHn6HQFiyMKMjRdiV2MpNHU=";
          version = "580.105.08";
        };
      };
    };
  };
}
