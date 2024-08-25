{
  lib,
  isWorkstation,
  ...
}: {
  programs.wezterm = lib.mkIf isWorkstation {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraConfig = ''
      local config = wezterm.config_builder()

      config.audible_bell = "Disabled"
      config.font = wezterm.font 'Cascadia Code NF'
      config.font_size = 9.0
      config.hide_tab_bar_if_only_one_tab = true
      config.color_scheme = "Catppuccin Mocha"

      return config
    '';
  };
}
