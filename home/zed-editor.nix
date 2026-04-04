_: {
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
