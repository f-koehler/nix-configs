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
          sha256 = "sha256-2cboGIZy8+t03QTPpp3VhHn6HQFiyMKMjRdiV2MpNHU=";
          version = "580.105.08";
        };
      };
    };
  };
}
