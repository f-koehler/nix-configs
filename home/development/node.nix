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
          pkgs.nodejs
          pkgs.pnpm
          pkgs.yarn
        ];
      };
}
