{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = pkgs.stdenv.isDarwin;
    extensions = with pkgs; [
      vscode-extensions.editorconfig.editorconfig
      vscode-extensions.esbenp.prettier-vscode
      vscode-extensions.github.copilot
      vscode-extensions.github.vscode-github-actions
      vscode-extensions.github.vscode-pull-request-github
      vscode-extensions.james-yu.latex-workshop
      vscode-extensions.mechatroner.rainbow-csv
      vscode-extensions.mkhl.direnv
      vscode-extensions.ms-azuretools.vscode-docker
      vscode-extensions.ms-python.black-formatter
      vscode-extensions.ms-python.isort
      vscode-extensions.ms-pyright.pyright
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
      vscode-extensions.tamasfe.even-better-toml
      vscode-extensions.usernamehw.errorlens
      vscode-extensions.vscode-icons-team.vscode-icons
      vscode-extensions.charliermarsh.ruff
      vscode-extensions.jnoortheen.nix-ide
      vscode-extensions.asvetliakov.vscode-neovim
    ];
    userSettings = {
      "workbench.iconTheme" = "vscode-icons";
      "editor.formatOnSave" = true;
      "editor.fontSize" = 12;
      "terminal.integrated.fontSize" = 10;
      "terminal.integrated.fontFamily" = "Hack Nerd Font";
      "cmake.options.statusBarVisibility" = "compact";
      "cmake.showOptionsMovedNotification" = false;
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
    };
  };
}
