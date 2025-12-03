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
      vim_mode = true;
    };
  };
}
