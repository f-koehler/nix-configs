{
  config,
  lib,
  nodeConfig,
  ...
}:
{
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      bashls.enable = nodeConfig.isWorkstation;
      clangd.enable = nodeConfig.isWorkstation;
      cmake.enable = nodeConfig.isWorkstation;
      gopls.enable = nodeConfig.isWorkstation;
      nil_ls.enable = true;
      pyright.enable = nodeConfig.isWorkstation;
      qmlls = {
        enable = nodeConfig.isWorkstation;
        autostart = true;
        cmd = [
          "${lib.getExe' config.programs.nixvim.plugins.lsp.servers.qmlls.package "qmlls"}"
          "-E"
        ];
      };
      rust_analyzer = {
        enable = nodeConfig.isWorkstation;
        installCargo = false;
        installRustc = false;
      };
    };
    keymaps = {
      lspBuf = {
        "gd" = "definition";
        "gD" = "declaration";
        "gr" = "references";
        "<leader>la" = "code_action";
        "<leader>lr" = "rename";
      };
    };
  };
}
