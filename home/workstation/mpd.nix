{ config, ... }:
{
  programs.ncmpcpp.enable = true;
  services = {
    mpd = {
      enable = true;
      musicDirectory = "/media/media1/soundtracks";
      network = {
        listenAddress = "127.0.0.1";
        port = 6600;
        startWhenNeeded = true;
      };
    };
    mpdris2 = {
      enable = true;
      mpd = {
        inherit (config.services.mpd.network) port;
        host = config.services.mpd.network.listenAddress;
      };
    };
  };
}
