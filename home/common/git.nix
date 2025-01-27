_: {
  programs = {
    git = {
      enable = true;
      userEmail = "fabian.koehler@proton.me";
      userName = "Fabian Koehler";
      signing = {
        key = "C5DC80511469AD81C84E3564D55A35AFB2900A11";
      };
      delta.enable = true;
      extraConfig = {
        pull = {
          rebase = "false";
        };
        init = {
          defaultBranch = "main";
        };
        color = {
          ui = "auto";
        };
      };
    };
    lazygit = {
      enable = true;
    };
  };
  catppuccin.lazygit = {
    enable = true;
    accent = "mauve";
    flavor = "mocha";
  };
}
