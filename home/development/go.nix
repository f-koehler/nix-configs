{ pkgs, ... }:
{
  home.packages = [
    pkgs.go
    pkgs.gotools
    pkgs.golangci-lint
  ];
}
