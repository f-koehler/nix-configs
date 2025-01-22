_: {
  programs.nixvim.keymaps = [
    {
      action = ":lua vim.lsp.buf.definition()<CR>";
      key = "gd";
      mode = "n";
      options = {
        silent = true;
        desc = "Go to definition.";
      };
    }
    {
      action = ":lua vim.lsp.buf.declaration()<CR>";
      key = "gD";
      mode = "n";
      options = {
        silent = true;
        desc = "Go to declaration.";
      };
    }
  ];
}
