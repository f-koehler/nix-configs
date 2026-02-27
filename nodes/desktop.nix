_: {
  home = {
    username = "fkoehler";
    homeDirectory = "/home/fkoehler";
  };
  targets = {
    genericLinux = {
      enable = true;
      gpu = {
        enable = true;
        nvidia = {
          enable = true;
          sha256 = "sha256-gCD139PuiK7no4mQ0MPSr+VHUemhcLqerdfqZwE47Nc=";
          version = "580.119.02";
        };
      };
    };
  };
}
