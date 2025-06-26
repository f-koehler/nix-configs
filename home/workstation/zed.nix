{
  lib,
  pkgs,
  config,
  ...
}:
{
  stylix.targets.zed.enable = config.programs.zed-editor.enable;
  programs.zed-editor = {
    enable = false;
    installRemoteServer = true;
    extensions = [
      "dockerfile"
      "docker-compose"
      "env"
      "neocmake"
      "nix"
    ];
    userSettings = {
      buffer_line_height = "comfortable";
      terminal_line_height = "standard";

      load_direnv = "shell_hook";
      telemetry.metrics = false;
      vim_mode = true;
      lsp = {
        clangd = {
          binary = {
            path = "${lib.getExe' pkgs.clang-tools "clangd"}";
            arguments = [ ];
          };
        };
      };
    };
  };
}
