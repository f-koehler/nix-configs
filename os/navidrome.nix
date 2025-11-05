{ myLib, ... }:
myLib.os.mkSelfHostedService {
  enable = true;
  name = "navidrome";
  datasets = [
    "data"
  ];
  containers = {
    navidrome = {
      image = "deluan/navidrome:0.58.0";
      network = "navidrome";
    };
  };
  tailscale = {
    enable = true;
    serveHost = "navidrome";
    servePort = 4533;
  };
}
