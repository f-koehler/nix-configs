_: {
  programs.gh = {
    enable = true;
    settings = {
      settings = {
        editor = "nvim";
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
  };
}
