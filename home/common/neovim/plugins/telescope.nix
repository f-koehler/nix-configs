_: {
  programs.nixvim.plugins.telescope = {
    enable = true;
    keymaps = {
      "<C-p>" = {
        action = "find_files";
        options.desc = "Telescope Git Files";
      };
    };
  };
}
