_:
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
      settings = {
        # UI
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;

        "extensions.pocket.enabled" = false;
      };
    };
    policies = {
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
}
