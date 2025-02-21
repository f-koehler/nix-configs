{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.libreoffice-qt6-fresh
    pkgs.hunspell
    pkgs.hunspellDicts.de_DE
    pkgs.hunspellDicts.en_US-large
  ];
}
