{ config, pkgs, ... }:
{
  # language toolchains live in home/development, only system level pieces are here
  environment.systemPackages = [
    # has to match the running kernel
    config.boot.kernelPackages.perf
  ];

  # run unpatched binaries (uv/pip wheels, ...)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      libffi
      glibc
    ];
  };
}
