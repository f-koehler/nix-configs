{ lib, pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
    extensions = [
      "env"
      "neocmake"
      "nix"
    ];
    userSettings = {
      buffer_font_family = "Cascadia Code NF";
      buffer_font_size = 12;
      load_direnv = "shell_hook";
      telemetry.metrics = false;
      ui_font_size = 14;
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
