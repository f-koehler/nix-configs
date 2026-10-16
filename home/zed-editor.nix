{
  pkgs,
  config,
  hasTag,
  lib,
  ...
}:
let
  nvidiaDrivers = config.targets.genericLinux.gpu.drivers;

  zed-editor-nvidia = pkgs.symlinkJoin {
    name = "zed-editor-nvidia-${pkgs.zed-editor.version}";
    paths = [ pkgs.zed-editor ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/zeditor \
        --set VK_ICD_FILENAMES "${nvidiaDrivers}/share/vulkan/icd.d/nvidia_icd.json" \
        --set __EGL_VENDOR_LIBRARY_FILENAMES "${nvidiaDrivers}/share/glvnd/egl_vendor.d/10_nvidia.json" \
        --set __GLX_VENDOR_LIBRARY_NAME nvidia \
        --prefix LD_LIBRARY_PATH : "${nvidiaDrivers}/lib"
    '';
    passthru = {
      inherit (pkgs.zed-editor) remote_server remoteServerExecutableName;
    };
    inherit (pkgs.zed-editor) meta;
  };
in
{
  home.packages = [ pkgs.texlab ];
  programs.zed-editor = {
    enable = true;
    package = if hasTag "gpu-nvidia" then zed-editor-nvidia else pkgs.zed-editor;
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
}
