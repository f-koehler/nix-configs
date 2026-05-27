{ pkgs, ... }:
{
  home.packages = [ pkgs.texlab ];
  programs.zed-editor = {
    enable = true;
    package = null;
    installRemoteServer = true;
    extensions = [
      "docker-compose"
      "dockerfile"
      "env"
      "html"
      "latex"
      "make"
      "neocmake"
      "nix"
      "qml"
      "toml"
      "xml"
    ];
    userSettings = {
      colorize_brackets = true;
      lsp = {
        texlab = {
          settings = {
            texlab = {
              build = {
                onSave = false;
              };
            };
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
