{ pkgs, ... }:
{
  home.packages = [
    pkgs.texliveFull
    pkgs.texlab
    pkgs.tectonic
  ];
}
