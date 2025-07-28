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
    extraPackages = with pkgs; [
      nil
      nixd
    ];
    extensions = [
      "catppuccin"
      "catppuccin-icons"
      "docker-compose"
      "dockerfile"
      "env"
      "html"
      "make"
      "neocmake"
      "nix"
      "scss"
      "snakemake"
      "toml"
    ];
    userSettings = {
      buffer_font_family = "Cascadia Code NF";
      buffer_line_height = "standard";
      terminal = {
        font_family = "Cascadia Code NF";
        line_height = "standard";
      };
      ui_font_family = "Noto Sans";

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
