{ myLib, ... }:
myLib.os.mkSelfHostedService {
  enable = true;
  name = "jellyfin";
  containers = {
    app = {
      image = "jellyfin/jellyfin:10.11.2";
      environments = {
        JELLYFIN_PublishedServerUrl = "https://jellyfin.corgi-dojo.ts.net";
      };
    };
  };
  tailscale = {
    enable = true;
    serveHost = "app";
    servePort = 8096;
  };
}
