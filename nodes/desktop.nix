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
          sha256 = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
          version = "595.58.03";
        };
      };
    };
  };
}
