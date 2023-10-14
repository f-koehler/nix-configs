_: {
  programs.git = {
    enable = true;
    userEmail = "me@fkoehler.org";
    userName = "Fabian Köhler";
    signing = {
      key = "C5DC80511469AD81C84E3564D55A35AFB2900A11";
    };
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
}
