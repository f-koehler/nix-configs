_: {
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = "fallback";
          timeout_ms = 500;
        };
        notify_on_error = true;
        formatters_by_ft = {
          cpp = [ "clang-format" ];
          python = [ "ruff_format" ];
        };
      };
    };
  };
}
