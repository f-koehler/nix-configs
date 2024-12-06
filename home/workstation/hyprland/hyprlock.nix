_: {
  programs = {
    hyprlock = {
      enable = true;
    };
  };
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        # "$mod, L, exec, ${lib.getExe pkgs.hyprlock} --immediate"
      ];
    };
  };
}
