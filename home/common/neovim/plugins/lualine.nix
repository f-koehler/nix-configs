_: {
  programs.nixvim.plugins.lualine = {
    enable = true;
    settings.options = {
      globalstatus = true;
      icons_enabled = true;
    };
  };
}
