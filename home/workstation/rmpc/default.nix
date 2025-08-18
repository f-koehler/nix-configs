{ config, ... }:
{
  programs.rmpc = {
    enable = true;
    config = ''
      (
          address: "${config.services.mopidy.settings.mpd.hostname}:${toString config.services.mopidy.settings.mpd.port}",
          password: None,
          theme: Some("catppuccin"),
          enable_mosue: true,
          enable_config_hot_reload: true,
      )
    '';
  };
  home.file.".config/rmpc/themes/catppuccin.ron".source = ./catppuccin.ron;
}
