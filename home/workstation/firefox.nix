{ config, ... }:
let
  extensionsToInstall = [
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" # bitwarden
    "gdpr@cavi.au.dk" # consent-o-matic
    "addon@darkreader.org" # dark reader
    "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack" # raindrop
    "uBlock0@raymondhill.net" # ublock origin
    "zotero@chnm.gmu.edu" # zotero connector
  ];
in
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions.force = true;
      settings = {
        # UI
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
      };
    };
    policies = {
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DontCheckDefaultBrowser = true;

      # Hardware acceleration
      HardwareAcceleration = true;
      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = false;
      };

      # Privacy
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };

      # Firefox buitin homepage
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };

      # Do not store any passwords
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;

      # Browser Extensions
      ExtensionSettings = builtins.listToAttrs (
        map (extension: {
          name = extension;
          value = {
            install_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${extension}/latest.xpi";
          };
        }) extensionsToInstall
      );
      ExtensionUpdate = true;
    };
  };
  stylix.targets.firefox = {
    inherit (config.programs.firefox) enable;
    profileNames = [ "default" ];
    colorTheme.enable = true;
  };
}
