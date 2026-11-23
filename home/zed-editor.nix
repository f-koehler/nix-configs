{
  config,
  pkgs,
  lib,
  hasAnyTagOf,
  ...
}:
{
  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        programs.zed-editor = {
          enable = true;
          package = pkgs.zed-editor;
          installRemoteServer = true;
          extraPackages = config.editorTools.packages ++ [ pkgs.nixd ];
          extensions = [
            "clice"
            "docker-compose"
            "dockerfile"
            "env"
            "github-actions"
            "harper"
            "html"
            "latex"
            "lua"
            "make"
            "neocmake"
            "nix"
            "qml"
            "terraform"
            "toml"
            "xml"
          ];
          userSettings = {
            agent = {
              dock = "right";
              threads_sidebar.position = "right";
            };
            agent_servers.claude-acp.type = "registry";
            colorize_brackets = true;
            edit_predictions.provider = "copilot";
            git_panel.dock = "left";
            outline_panel.dock = "left";
            project_panel.dock = "left";
            languages = {
              # try clice instead of zed's built-in clangd; note that
              # `editor: switch source header` only works with clangd
              "C++".language_servers = [
                "clice"
                "!clangd"
                "..."
              ];
              C.language_servers = [
                "clice"
                "!clangd"
                "..."
              ];
              Nix.language_servers = [
                "nixd"
                "nil"
              ];
            };
            load_direnv = "shell_hook";
            lsp = {
              # pin the nix-packaged server, so the extension never downloads
              # a release of its own (which would not run on NixOS)
              clice.binary = {
                path = lib.getExe pkgs.clice;
                arguments = [ "serve" ];
              };
              copilot.binary = {
                path = lib.getExe pkgs.copilot-language-server;
                arguments = [ "--stdio" ];
              };
              texlab = {
                settings = {
                  texlab = {
                    build = {
                      onSave = false;
                    };
                  };
                };
              };
            };
            telemetry.metrics = true;
            ui_font_size = 14;
            vim = {
              toggle_relative_line_numbers = true;
            };
            vim_mode = true;
            which_key = {
              enabled = true;
            };
          };
        };
      };
}
