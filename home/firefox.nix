{ pkgs, config, ... }:
{
  # The nixpkgs Firefox wrapper sets MOZ_LEGACY_PROFILES=1, forcing Firefox to
  # read profiles from ~/.mozilla/firefox/ instead of the XDG path that
  # home-manager now uses (~/.config/mozilla/firefox/). This profiles.ini
  # bridges the gap by pointing Firefox at the home-manager-managed profile.
  home.file.".mozilla/firefox/profiles.ini" = {
    force = true;
    text = ''
      [General]
      StartWithLastProfile=1
      Version=2

      [Profile0]
      Default=1
      IsRelative=0
      Name=default
      Path=${config.home.homeDirectory}/.config/mozilla/firefox/default
    '';
  };

  programs.firefox = {
    enable = true;
    package = if pkgs.stdenv.isLinux then pkgs.firefox else pkgs.firefox-bin;
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
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Nix";
            bookmarks = [
              {
                name = "home-manager options";
                url = "https://nix-community.github.io/home-manager/options.xhtml";
              }
              {
                name = "Nix Packages";
                url = "https://search.nixos.org/packages?channel=unstable&";
              }
              {
                name = "Nix Options";
                url = "https://search.nixos.org/options?channel=unstable&";
              }
            ];
          }
          {
            name = "GitHub";
            url = "https://github.com";
          }
        ];
      };
    };
    policies = {
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/uBlock0@raymondhill.net/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };

        # Zotero
        "zotero@chnm.gmu.edu" = {
          default_area = "menuarea";
          install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
          installation_mode = "force_installed";
          private_browsing = false;
        };

        # Karakeep
        "addon@karakeep.app" = {
          default_area = "menuarea";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/addon@karakeep.app/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
        };

        # Firefox Color
        "FirefoxColor@mozilla.com" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/FirefoxColor@mozilla.com/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
        };

        # Darkreader
        "addon@darkreader.org" = {
          default_area = "menuarea";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/addon@darkreader.org/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };

        # Tridactyl
        "tridactyl.vim@cmcaine.co.uk" = {
          default_area = "menuarea";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl.vim@cmcaine.co.uk/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };
  };
}
