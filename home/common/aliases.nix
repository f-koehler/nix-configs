{
  config,
  lib,
  isLinux,
  ...
}:
{
  home.shellAliases = {
    "cp" = "cp -i";
    "mv" = "mv -i";
    "rm" = "rm -i";
    "cat" = "${lib.getExe' config.programs.bat.package "bat"} --style=plain --paging=never";
    "open" = lib.mkIf isLinux "xdg-open";
    "lg" = "${lib.getExe' config.programs.lazygit.package "lazygit"}";
    "tw" = "${lib.getExe' config.programs.lazygit.package "taskwarrior-tui"}";
  };
}
