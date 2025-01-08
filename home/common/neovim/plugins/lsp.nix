{nodeConfig, ...}: {
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      bashls.enable = nodeConfig.isWorkstation;
      clangd.enable = nodeConfig.isWorkstation;
      cmake.enable = nodeConfig.isWorkstation;
      gopls.enable = nodeConfig.isWorkstation;
      nil_ls.enable = true;
      pyright.enable = nodeConfig.isWorkstation;
      rust_analyzer = {
        enable = nodeConfig.isWorkstation;
        installCargo = false;
        installRustc = false;
      };
    };
  };
}
