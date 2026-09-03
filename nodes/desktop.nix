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
      gpu.enable = false;
    };
  };
}
