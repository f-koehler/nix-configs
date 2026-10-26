{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.go
    pkgs.gotools
    pkgs.golangci-lint
  ];
}
