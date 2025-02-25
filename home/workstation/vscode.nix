{
  pkgs,
  isDarwin,
  ...
}:
{
  home.packages = with pkgs; [
    ruff
    vscode

    clang-tools
  ];
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = isDarwin;
    extensions = [
      pkgs.vscode-marketplace.akiramiyakoda.cppincludeguard
      pkgs.vscode-marketplace.asvetliakov.vscode-neovim
      pkgs.vscode-marketplace.catppuccin.catppuccin-vsc
      pkgs.vscode-marketplace.catppuccin.catppuccin-vsc-icons
      pkgs.vscode-marketplace.charliermarsh.ruff
      pkgs.vscode-marketplace.codeium.codeium
      pkgs.vscode-marketplace.eamodio.gitlens
      pkgs.vscode-marketplace.ecmel.vscode-html-css
      pkgs.vscode-marketplace.editorconfig.editorconfig
      pkgs.vscode-marketplace.efanzh.graphviz-preview
      pkgs.vscode-marketplace.esbenp.prettier-vscode
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
      pkgs.vscode-marketplace.myriad-dreamin.tinymist
      pkgs.vscode-marketplace.redhat.vscode-xml
      pkgs.vscode-marketplace.redhat.vscode-yaml
      pkgs.vscode-marketplace.rust-lang.rust-analyzer
      pkgs.vscode-marketplace.snakemake.snakemake-lang
      pkgs.vscode-marketplace.stephanvs.dot
      pkgs.vscode-marketplace.tailscale.vscode-tailscale
      pkgs.vscode-marketplace.tamasfe.even-better-toml
      pkgs.vscode-marketplace.tfehlmann.snakefmt
      pkgs.vscode-marketplace.usernamehw.errorlens
      pkgs.vscode-marketplace.vscode-icons-team.vscode-icons
    ];
    userSettings = {
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      "[python]" = {
        "editor.defaultFormatter" = "charliermarsh.ruff";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typst]" = {
        "editor.formatOnSave" = true;
      };

      "debug.allowBreakpointsEverywhere" = false;

      "C/C++ Include Guard.Macro Type" = "Filepath";
      "C/C++ Include Guard.Path Skip" = 1;
      "C/C++ Include Guard.Remove Extension" = false;
      "C_Cpp.clang_format_fallbackStyle" = "LLVM";
      #"C_Cpp.intelliSenseEngine" = "disabled";
      "C_Cpp.loggingLevel" = "Debug";
      "C_Cpp.codeAnalysis.clangTidy.enabled" = true;
      "C_Cpp.codeAnalysis.clangTidy.path" = "${pkgs.clang-tools}/bin/clang-tidy";
      "C_Cpp.clang_format_path" = "${pkgs.clang-tools}/bin/clang-format";
      "C_Cpp.codeAnalysis.runAutomatically" = false;

      "cmake.options.statusBarVisibility" = "compact";
      "cmake.showOptionsMovedNotification" = false;
      "cmake.configureOnOpen" = true;
      "cmake.pinnedCommands" = [
        "workbench.action.tasks.configureTaskRunner"
        "workbench.action.tasks.runTask"
      ];
      "codeium.enableConfig" = {
        "*" = true;
        "nix" = true;
      };
      "editor.fontSize" = 12;
      "editor.formatOnSave" = true;
      "editor.fontFamily" = "Cascadia Code NF";
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
      "git.autofetch" = true;
      "git.path" = "${pkgs.git}/bin/git";
      "latex-workshop.latex.recipe.default" = "latexmk (lualatex)";
      "latex-workshop.hover.preview.mathjax.extensions" = [ "braket" ];
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = [ "nixfmt-rfc-style" ];
          };
        };
      };
      "redhat.telemetry.enabled" = false;
      "remote.SSH.useLocalServer" = false;
      "ruff.path" = [ "${pkgs.ruff}/bin/ruff" ];
      "tailscale.portDiscovery.enabled" = false;
      "terminal.integrated.fontFamily" = "Cascadia Code NF";
      "terminal.integrated.fontSize" = 12;
      "terminal.integrated.persistentSessionScrollback" = 10000;
      "terminal.integrated.scrollback" = 100000;
      "tinymist.formatterMode" = "typstyle";
      "vsicons.dontShowNewVersionMessage" = true;
      "window.titleBarStyle" = "custom";
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "remote.SSH.remotePlatform" = {
        "homeserver" = "linux";
        "homeserver.corgi-dojo.ts.net" = "linux";
      };
      "vscode-neovim.neovimClean" = true;

      "rust-analyzer.testExplorer" = true;
    };
  };
}
