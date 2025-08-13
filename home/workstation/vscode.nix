{
  config,
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  stylix.targets.vscode.enable = false;
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = isDarwin;
      extensions = [
        pkgs.vscode-marketplace.akiramiyakoda.cppincludeguard
        pkgs.vscode-marketplace.asvetliakov.vscode-neovim
        pkgs.vscode-marketplace.catppuccin.catppuccin-vsc
        pkgs.vscode-marketplace.catppuccin.catppuccin-vsc-icons
        pkgs.vscode-marketplace.editorconfig.editorconfig
        pkgs.vscode-marketplace.jnoortheen.nix-ide
        pkgs.vscode-marketplace.mermaidchart.vscode-mermaid-chart
        pkgs.vscode-marketplace.mkhl.direnv
        pkgs.vscode-marketplace.ms-vscode.cmake-tools
        pkgs.vscode-marketplace.ms-vscode.cpptools
        pkgs.vscode-marketplace.rust-lang.rust-analyzer
      ];
      userSettings = {
        "direnv.path.executable" = "${lib.getExe' config.programs.direnv.package "direnv"}";
        "direnv.restart.automatic" = true;
        "editor.fontFamily" = "'Cascadia Code NF', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
        "editor.minimap.enabled" = false;
        "rust-analyzer.testExplorer" = false;
        "terminal.integrated.fontLigatures.enabled" = false;
        "vscode-neovim.neovimClean" = false;
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";

        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };
      };
    };
  };
}
