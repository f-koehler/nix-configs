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
          sha256 = "sha256-ReLUwTSiPDXlDyU6SqY+fl6NF+PRhdSgfIpY6WEu05I=";
          version = "610.43.03";
        };
      };
    };
  };
}
