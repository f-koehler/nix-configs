_: {
  programs.zed-editor = {
    enable = true;
    extensions = ["nix"];
    userSettings = {
      vim_mode = true;
    };
  };
}
