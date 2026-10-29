{ lib, pkgs, ... }:
{
  home.packages = [
    pkgs.clang-tools
    pkgs.cmake
    pkgs.gnumake
    pkgs.ninja
  ]
  # on macOS gcc would shadow the Apple toolchain in PATH
  ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.gcc
    (pkgs.runCommand "gcc-lto-tools" { } ''
      mkdir -p $out/bin
      for t in gcc-ar gcc-nm gcc-ranlib; do
        ln -s ${pkgs.gcc.cc}/bin/$t $out/bin/$t
      done
    '')
  ];
}
