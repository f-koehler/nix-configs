{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    dictionaries = [ pkgs.hunspellDictsChromium.en_US ];
    extensions = [
      {
        id = "nngceckbapebfimnlniiiahkandclblb"; # bitwarden
      }
      {
        id = "mdjildafknihdffpkfmmpnpoiajfjnjd"; # consent-o-matic
      }
      {
        id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; # dark reader
      }
      {
        id = "ldgfbffkinooeloadekpmfoklnobpien"; # raindrop
      }
      {
        id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; # ublock origin lite
      }
      {
        id = "ekhagklcjbdpajgpjgmbionohlpdbjgc"; # zotero connector
      }
    ];
    nativeMessagingHosts = [
      pkgs.kdePackages.plasma-browser-integration
    ];
  };
}
