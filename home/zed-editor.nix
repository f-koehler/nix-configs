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
      telemetry.metrics = false;
      ui_font_size = 14;
      vim_mode = true;
    };
  };
}
