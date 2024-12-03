{isWorkstation, ...}: {
  programs.zed-editor = {
    enable = isWorkstation;
    extensions = ["nix"];
    userSettings = {
      buffer_font_family = "Cascadia Code NF";
      buffer_font_size = 12;
      telemetry.metrics = false;
      ui_font_size = 14;
      vim_mode = true;
    };
  };
}
