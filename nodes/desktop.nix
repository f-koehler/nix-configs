_: {
  home = {
    username = "fkoehler";
    homeDirectory = "/home/fkoehler";
  };
  services.nvibrant = {
    enable = false;
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
          version = "610.57.04";
          sha256 = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
        };
      };
    };
  };
}
