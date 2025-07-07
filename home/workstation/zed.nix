{
  lib,
  pkgs,
  config,
  ...
}:
{
  stylix.targets.zed.enable = false;
  catppuccin.zed = lib.mkIf config.programs.zed-editor.enable {
    enable = true;
    icons.enable = true;
    italics = true;
  };
  programs.zed-editor = {
    enable = true;
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
