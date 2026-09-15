_: {
  nodeTags = [ "gpu-nvidia" ];
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
          version = "615.71.09";
          sha256 = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
        };
      };
    };
  };
}
