{
  lib,
  pkgs,
  config,
  nodeConfig,
  ...
}:
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
      buffer_font_family = builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
      buffer_line_height = "comfortable";
      buffer_font_size = 13; # nodeConfig.fontSizeMonospace;
      terminal_font_size = 13; # nodeConfig.fontSizeMonospace;
      terminal_font_family = builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
      terminal_line_height = "standard";
      ui_font_size = 14; # nodeConfig.fontSize;
      ui_font_family = builtins.elemAt config.fonts.fontconfig.defaultFonts.sansSerif 0;

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
