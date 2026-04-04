{ pkgs, lib, ... }:
{
  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
    extensions = [
      "docker-compose"
      "dockerfile"
      "env"
      "html"
      "make"
      "neocmake"
      "nix"
      "toml"
    ];
    userSettings = {
      colorize_brackets = true;
      languages = {
        Nix = {
          formatter = {
            external = {
              command = "${lib.getExe' pkgs.nixfmt "nixfmt"}";
              arguments = [ "" ];
            };
          };
          language_servers = [
            "nixd"
            "!nild"
          ];
        };
      };
      lsp = {
        nixd = {
          binary = {
            path = "${lib.getExe' pkgs.nixd "nixd"}";
          };
        };
      };
      telemetry.metrics = true;
      ui_font_size = 14;
      vim = {
        toggle_relative_line_numbers = true;
      };
      vim_mode = true;
      which_key = {
        enabled = true;
      };
    };
  };
}
