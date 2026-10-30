{
  lib,
  pkgs,
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
        home.packages = [
          pkgs.python3
          pkgs.uv
        ];
      };
}
