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
}
