{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.clang-tools
    pkgs.cmake
    pkgs.gcc
    pkgs.gnumake
    pkgs.ninja
    (pkgs.runCommand "gcc-lto-tools" { } ''
      mkdir -p $out/bin
      for t in gcc-ar gcc-nm gcc-ranlib; do
        ln -s ${pkgs.gcc.cc}/bin/$t $out/bin/$t
      done
    '')
  ];
}
