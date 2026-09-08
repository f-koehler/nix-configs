{
  pkgs,
  config,
  hasTag,
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
    extensions = [
      "docker-compose"
      "dockerfile"
      "env"
      "harper"
      "html"
      "latex"
      "make"
      "neocmake"
      "nix"
      "qml"
      "terraform"
      "toml"
      "xml"
    ];
    userSettings = {
      colorize_brackets = true;
      load_direnv = "shell_hook";
      lsp = {
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
