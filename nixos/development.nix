{
  pkgs,
  lib,
  hasAnyTagOf,
  ...
}:
{
  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
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
