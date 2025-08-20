{
  nodeConfig,
  ...
}:
{
  programs.nixvim.lsp = {
    keymaps = [
      {
        key = "gd";
        lspBufAction = "definition";
      }
      {
        key = "gD";
        lspBufAction = "declaration";
      }
      {
        key = "K";
        lspBufAction = "hover";
      }
      {
        key = "<leader>la";
        lspBufAction = "code_action";
      }
      {
        key = "<leader>lr";
        lspBufAction = "rename";
      }
    ];
    servers = {
      clangd = {
        enable = nodeConfig.isWorkstation;
        settings = {
          cmd = [
            "clangd"
            "--background-index"
          ];
          filetypes = [
            "c"
            "cpp"
          ];
          root_markers = [
            "compile_commands.json"
            "compile_flags.txt"
          ];
        };
      };
    };
  };
}
