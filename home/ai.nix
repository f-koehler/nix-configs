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
          pkgs.qwen-code
        ];
        programs = {
          codex = {
            enable = true;
          };
          claude-code = {
            enable = true;
          };
          github-copilot-cli = {
            enable = true;
          };
        };
      };
}
