{
  pkgs,
  config,
  lib,
  hasTag,
  ...
}:
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
        "browser.urlbar.showSearchSuggestionsFirst" = false; # Show bookmarks/history/open tabs before search engine suggestions in the address bar
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
          (lib.mkIf (hasTag "speqtral") {
            name = "SpeQtral";
            bookmarks = [
              {
                name = "Redmine (All Projects)";
                url = "http://10.1.5.5:3000/agile/board?set_filter=1&f%5B%5D=assigned_to_id&op%5Bassigned_to_id%5D=%3D&v%5Bassigned_to_id%5D%5B%5D=me&f%5B%5D=status_id&op%5Bstatus_id%5D=%3D&f_status%5B%5D=1&f_status%5B%5D=7&f_status%5B%5D=2&f_status%5B%5D=4&f_status%5B%5D=8&f_status%5B%5D=11&f_status%5B%5D=10&f_status%5B%5D=6&f_status%5B%5D=9&f_status%5B%5D=12&f_status%5B%5D=16&f_status%5B%5D=17&c%5B%5D=tracker&c%5B%5D=estimated_hours&c%5B%5D=spent_hours&c%5B%5D=done_ratio&c%5B%5D=parent&c%5B%5D=assigned_to&c%5B%5D=cf_4&c%5B%5D=cf_3";
              }
              {
                name = "pve-qnex-apps";
                url = "pve-qnex-apps.speqtranet.com:8006";
              }
              {
                name = "GitHub Actions Runners";
                url = "https://github.com/organizations/SpeQtral/settings/actions/runners";
              }
            ];
          })
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
            name = "C++";
            bookmarks = [
              {
                name = "cppreference";
                url = "https://en.cppreference.com/w/";
              }
              {
                name = "C++ Standard Draft";
                url = "https://eel.is/c++draft/";
              }
            ];
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

        # KeePassXC-Browser
        "KeePassXC-Browser" = {
          default_area = "menuarea";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/KeePassXC-Browser/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };
  };
}
