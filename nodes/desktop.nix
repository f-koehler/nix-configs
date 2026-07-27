_: {
  home = {
    username = "fkoehler";
    homeDirectory = "/home/fkoehler";
  };
  services.nvibrant = {
    enable = true;
    dithering = [
      false
      false
      false
    ];
    vibrancy = [
      "125%"
      "125%"
      "125%"
    ];
  };
  targets = {
    genericLinux = {
      enable = true;
      gpu = {
        enable = true;
        nvidia = {
          enable = true;
          sha256 = "sha256-MDSgVLtM33dS/43CclZMsQVROAS/9TU4lFkBsWyndGM=";
          version = "610.43.02";
        };
      };
    };
  };
}
