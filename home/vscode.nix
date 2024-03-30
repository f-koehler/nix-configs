{
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.ruff
  ];
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = pkgs.stdenv.isDarwin;
    extensions =
      [
        pkgs.vscode-marketplace.akiramiyakoda.cppincludeguard
        pkgs.vscode-marketplace.asvetliakov.vscode-neovim
        pkgs.vscode-marketplace.charliermarsh.ruff
        pkgs.vscode-marketplace.eamodio.gitlens
        pkgs.vscode-marketplace.editorconfig.editorconfig
        pkgs.vscode-marketplace.efanzh.graphviz-preview
        pkgs.vscode-marketplace.esbenp.prettier-vscode
        pkgs.vscode-marketplace.github.copilot
        pkgs.vscode-marketplace.github.vscode-github-actions
        pkgs.vscode-marketplace.github.vscode-pull-request-github
        pkgs.vscode-marketplace.james-yu.latex-workshop
        pkgs.vscode-marketplace.jnoortheen.nix-ide
        pkgs.vscode-marketplace.mechatroner.rainbow-csv
        pkgs.vscode-marketplace.mkhl.direnv
        pkgs.vscode-marketplace.ms-azuretools.vscode-docker
        pkgs.vscode-marketplace.ms-python.python
        pkgs.vscode-marketplace.ms-python.vscode-pylance
        pkgs.vscode-marketplace.ms-vscode-remote.remote-containers
        pkgs.vscode-marketplace.ms-vscode-remote.remote-ssh
        pkgs.vscode-marketplace.ms-vscode.hexeditor
        pkgs.vscode-marketplace.ms-vsliveshare.vsliveshare
        pkgs.vscode-marketplace.redhat.vscode-xml
        pkgs.vscode-marketplace.redhat.vscode-yaml
        pkgs.vscode-marketplace.stephanvs.dot
        pkgs.vscode-marketplace.tailscale.vscode-tailscale
        pkgs.vscode-marketplace.tamasfe.even-better-toml
        pkgs.vscode-marketplace.usernamehw.errorlens
        pkgs.vscode-marketplace.vscode-icons-team.vscode-icons
        pkgs.vscode-marketplace.ecmel.vscode-html-css
      ]
      ++ [
        # pkgs.vscode-extensions.ms-vscode.cmake-tools
        # pkgs.vscode-extensions.ms-vscode.makefile-tools
      ];
    userSettings = {
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      "[python]" = {
        "editor.defaultFormatter" = "charliermarsh.ruff";
      };

      "C/C++ Include Guard.Macro Type" = "Filepath";
      "C/C++ Include Guard.Path Skip" = 1;
      "C/C++ Include Guard.Remove Extension" = false;
      "C_Cpp.clang_format_fallbackStyle" = "LLVM";
      "C_Cpp.codeAnalysis.clangTidy.enabled" = true;
      "C_Cpp.formatting" = "clangFormat";

      "cmake.options.statusBarVisibility" = "compact";
      "cmake.showOptionsMovedNotification" = false;
      "cmake.configureOnOpen" = true;
      "editor.fontSize" = 12;
      "editor.formatOnSave" = true;
      "editor.fontFamily" = "Hack Nerd Font";
      "editor.minimap.enabled" = false;
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
      "git.autofetch" = true;
      "latex-workshop.latex.recipe.default" = "latexmk (lualatex)";
      "latex-workshop.hover.preview.mathjax.extensions" = ["braket"];
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = ["${pkgs.alejandra}/bin/alejandra"];
          };
        };
      };
      "redhat.telemetry.enabled" = false;
      "remote.SSH.useLocalServer" = false;
      "ruff.path" = ["${pkgs.ruff}/bin/ruff"];
      "terminal.integrated.fontFamily" = "Hack Nerd Font";
      "terminal.integrated.fontSize" = 12;
      "vsicons.dontShowNewVersionMessage" = true;
      "workbench.iconTheme" = "vscode-icons";
      "remote.SSH.remotePlatform" = {
        "homeserver" = "linux";
      };
    };
  };
}
