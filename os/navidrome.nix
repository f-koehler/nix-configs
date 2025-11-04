{ myLib, ... }:
myLib.os.mkSelfHostedService {
  enable = true;
  name = "navidrome";
  datasets = [
    "data"
  ];
  # containers = {
  #   navidrome = {
  #     image = "docker.io/deluan/navidrome:0.58.0";
  #     description = "Navidrome Music Server";
  #   };
  # };
  tailscale = {
    enable = true;
    serveHost = "app";
    servePort = 4533;
  };
}
