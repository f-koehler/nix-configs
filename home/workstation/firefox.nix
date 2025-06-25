_:
let
  extensionsToInstall = {
    "bitwarden" = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    "consent-o-matic" = "gdpr@cavi.au.dk";
    "dark-reader" = "addon@darkreader.org";
    "raindrop" = "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack";
    "ublock-origin" = "uBlock0@raymondhill.net";
    "zotero-connector" = "zotero@chnm.gmu.edu";
  };
in
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        # UI
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;

        "extensions.pocket.enabled" = false;
      };
    };
    policies = {
      # Browser Extensions
      ExtensionSettings = builtins.mapAttrs (_: slug: {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
      }) extensionsToInstall;
    };
  };
}
