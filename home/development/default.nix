{
  lib,
  pkgs,
  hasAnyTagOf,
  ...
}:
{
  imports = [
    ./cpp.nix
    ./go.nix
    ./latex.nix
    ./node.nix
    ./python.nix
    ./rust.nix
  ];

  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        home.packages = [
          pkgs.flamegraph
        ];
      };
}
