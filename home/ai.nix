{ pkgs, ... }:
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
  };
}
