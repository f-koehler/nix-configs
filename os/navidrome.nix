{ myLib, ... }:
myLib.os.mkSelfHostedService {
  enable = true;
  name = "navidrome";
  datasets = [
    "data"
  ];
  containers = {
    app = {
      image = "deluan/navidrome:0.58.0";
    };
  };
  tailscale = {
    enable = true;
    serveHost = "app";
    servePort = 4533;
  };
}
