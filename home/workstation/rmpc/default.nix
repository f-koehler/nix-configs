{ config, ... }:
{
  programs.rmpc = {
    enable = true;
    config = ''
      (
          address: "127.0.0.1:${toString config.services.mpd.network.port}",
          password: None,
          theme: Some("catppuccin"),
          enable_mosue: true,
          enable_config_hot_reload: true,
      )
    '';
  };
  home.file.".config/rmpc/themes/catppuccin.ron".source = ./catppuccin.ron;
}
