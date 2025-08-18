_: {
  programs.ncmpcpp.enable = true;
  services.mpd = {
    enable = true;
    musicDirectory = "/media/media1/soundtracks";
    network = {
      port = 6600;
      startWhenNeeded = true;
    };
  };
}
