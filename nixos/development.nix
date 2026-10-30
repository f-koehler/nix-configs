{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.fk.development.enable = lib.mkEnableOption "perf for profiling and nix-ld for running unpatched binaries";

  config = lib.mkIf config.fk.development.enable {
    environment.systemPackages = [
      pkgs.perf
    ];

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
  };
}
