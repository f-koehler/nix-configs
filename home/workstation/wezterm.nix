{
  pkgs,
  config,
  nodeConfig,
  ...
}:
{
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraConfig = ''
      local config = wezterm.config_builder()

      config.audible_bell = "Disabled"
      config.font = wezterm.font '${builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0}'
      config.font_size = ${toString nodeConfig.fontSizeMonospace}
      config.hide_tab_bar_if_only_one_tab = true
      config.color_scheme = "Catppuccin Mocha"

      return config
    '';
  };
}
