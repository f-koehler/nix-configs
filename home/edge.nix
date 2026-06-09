{
  pkgs,
  lib,
  config,
  ...
}:
let
  edge = lib.getExe' config.programs.microsoft-edge.finalPackage "microsoft-edge";
in
{
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
      categories = [
        "Chat"
        "InstantMessaging"
        "VideoConference"
      ];
    };
  };
}
