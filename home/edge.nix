{
  pkgs,
  lib,
  config,
  ...
}:
let
  edge = lib.getExe' config.programs.microsoft-edge.finalPackage "microsoft-edge";
in
lib.mkIf pkgs.stdenv.isLinux {
  programs.microsoft-edge = {
    enable = true;
    dictionaries = with pkgs; [
      hunspellDictsChromium.en_US
      hunspellDictsChromium.de_DE
    ];
    extensions = [
      {
        # Bitwarden
        id = "nngceckbapebfimnlniiiahkandclblb";
      }
      {
        # uBlock Origin Lite
        id = "ddkjiahejlhfcafbddmgiahcphecmpfh";
      }
      {
        # Dark Reader
        id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      }
      {
        # Surfingkeys
        id = "gfbliohnnapiefjpjlpjnehglfpaknnc";
      }
      {
        # Karakeep
        id = "kgcjekpmcjjogibpjebkhaanilehneje";
      }
      {
        # Zotero Connector
        id = "ekhagklcjbdpajgpjgmbionohlpdbjgc";
      }
    ];
  };
  xdg.desktopEntries = {
    teams = {
      name = "Teams";
      exec = "${edge} --app=https://teams.cloud.microsoft";
      terminal = false;
      icon = "${pkgs.fetchurl {
        url = "https://statics.teams.cdn.office.net/evergreen-assets/icons/windows/teams-icon-pwa-v2025-256.png";
        hash = "sha256-JZtYmSuAX4UiEgKme2cuZ6/nRPI3jsnC0e6B7CyDp2k=";
      }}";
      categories = [
        "Chat"
        "InstantMessaging"
        "VideoConference"
      ];
    };
  };
}
