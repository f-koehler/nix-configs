{ pkgs, ... }:
{
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
            name = "SpeQtral";
            bookmarks = [
              {
                name = "Redmine Agile";
                url = "http://10.1.5.5:3000/agile/board?set_filter=1&f%5B%5D=assigned_to_id&op%5Bassigned_to_id%5D=%3D&v%5Bassigned_to_id%5D%5B%5D=me&f%5B%5D=status_id&op%5Bstatus_id%5D=%3D&f_status%5B%5D=1&f_status%5B%5D=7&f_status%5B%5D=2&f_status%5B%5D=4&f_status%5B%5D=8&f_status%5B%5D=10&f_status%5B%5D=9&c%5B%5D=tracker&c%5B%5D=estimated_hours&c%5B%5D=spent_hours&c%5B%5D=done_ratio&c%5B%5D=parent&c%5B%5D=assigned_to&c%5B%5D=cf_4&c%5B%5D=cf_3";
              }
            ];
          }
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
}
