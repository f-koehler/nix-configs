{
  lib,
  pkgs,
  hasAnyTagOf,
  ...
}:
{
  options.editorTools.packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    description = "LSPs, formatters and linters put on the PATH of the editors (neovim, zed).";
  };

  config.editorTools.packages =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      (
        with pkgs;
        [
          ansible-language-server
          bash-language-server
          basedpyright
          cmake-format
          clang-tools
          docker-compose-language-service
          docker-language-server
          gopls
          harper
          lua-language-server
          neocmakelsp
          nil
          prettier
          ruff
          snakefmt
          statix
          taplo
          terraform-ls
          texlab
          tofu-ls
          zizmor
          nixfmt
          shfmt
          stylua
          terraform
          tex-fmt
          yaml-language-server
          kdePackages.qtdeclarative # qmlls and qmlformat
          vscode-extensions.vadimcn.vscode-lldb.adapter # codelldb for nvim-dap
        ]
      );
}
