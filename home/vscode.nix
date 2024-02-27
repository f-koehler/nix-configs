{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = pkgs.stdenv.isDarwin;
    extensions = with pkgs; [
      vscode-extensions.asvetliakov.vscode-neovim
      vscode-extensions.charliermarsh.ruff
      vscode-extensions.editorconfig.editorconfig
      vscode-extensions.esbenp.prettier-vscode
      vscode-extensions.github.copilot
      vscode-extensions.github.vscode-github-actions
      vscode-extensions.github.vscode-pull-request-github
      vscode-extensions.james-yu.latex-workshop
      vscode-extensions.jnoortheen.nix-ide
      vscode-extensions.mechatroner.rainbow-csv
      vscode-extensions.mkhl.direnv
      vscode-extensions.ms-azuretools.vscode-docker
      vscode-extensions.ms-pyright.pyright
      vscode-extensions.ms-python.black-formatter
      vscode-extensions.ms-python.isort
      vscode-extensions.ms-python.python
      vscode-extensions.ms-python.vscode-pylance
      vscode-extensions.ms-vscode-remote.remote-containers
      vscode-extensions.ms-vscode-remote.remote-ssh
      vscode-extensions.ms-vscode.cmake-tools
      vscode-extensions.ms-vscode.cpptools
      vscode-extensions.ms-vscode.hexeditor
      vscode-extensions.ms-vscode.makefile-tools
      vscode-extensions.ms-vsliveshare.vsliveshare
      vscode-extensions.redhat.vscode-xml
      vscode-extensions.redhat.vscode-yaml
      vscode-extensions.tailscale.vscode-tailscale
      vscode-extensions.tamasfe.even-better-toml
      vscode-extensions.usernamehw.errorlens
      vscode-extensions.vscode-icons-team.vscode-icons
    ];
    userSettings = {
      "C/C++ Include Guard.Macro Type" = "Filepath";
      "C/C++ Include Guard.Path Skip" = 1;
      "C/C++ Include Guard.Remove Extension" = false;
      "C_Cpp.clang_format_fallbackStyle" = "LLVM";
      "C_Cpp.codeAnalysis.clangTidy.enabled" = true;
      "cmake.options.statusBarVisibility" = "compact";
      "cmake.showOptionsMovedNotification" = false;
      "editor.fontSize" = 12;
      "editor.formatOnSave" = true;
      "editor.minimap.enabled" = false;
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
      "extensions.experimental.useUtilityProcess" = true;
      "git.autofetch" = true;
      "latex-workshop.latex.recipe.default" = "latexmk (lualatex)";
      "latex-workshop.hover.preview.mathjax.extensions" = [ "braket" ];
      "redhat.telemetry.enabled" = false;
      "terminal.integrated.fontFamily" = "Hack Nerd Font";
      "terminal.integrated.fontSize" = 10;
      "vsicons.dontShowNewVersionMessage" = true;
      "workbench.iconTheme" = "vscode-icons";
      "[python]" = {
        "editor.defaultFormatter" = "charliermarsh.ruff";
      };
    };
  };
}
