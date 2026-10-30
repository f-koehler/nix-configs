{
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
        home.packages = [ pkgs.texlab ];
        programs.zed-editor = {
          enable = true;
          package = pkgs.zed-editor;
          installRemoteServer = true;
          extraPackages = [
            pkgs.nil
            pkgs.nixd
          ];
          extensions = [
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
            languages.Nix.language_servers = [
              "nixd"
              "nil"
            ];
            load_direnv = "shell_hook";
            lsp = {
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
