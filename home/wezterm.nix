_: {
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm';
      local config = {}
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.audible_bell = "Disabled"
      config.font = wezterm.font('Hack Nerd Font')
      config.font_size = 9.0
      config.hide_tab_bar_if_only_one_tab = true
    
      return config
    '';
  };
}
