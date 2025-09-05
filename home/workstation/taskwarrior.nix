{ pkgs, ... }:
{
  programs.taskwarrior = {
    enable = true;
  };
  home.packages = [
    pkgs.python3Full
    pkgs.taskwarrior-tui
    pkgs.timewarrior
  ];
}
