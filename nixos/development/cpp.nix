{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.clang-tools
    pkgs.cmake
    pkgs.gcc
    pkgs.gnumake
  ];
}
