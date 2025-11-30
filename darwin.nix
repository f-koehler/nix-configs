_: {
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
  };
  services = {
    aerospace = {
      enable = true;
    };
    jankyborders = {
      enable = true;
    };
    sketchybar = {
      enable = true;
    };
  };
  system = {
    stateVersion = 6;
    primaryUser = "fkoehler";
    startup.chime = false;
  };
}
