{ myLib, ... }:
myLib.os.mkSelfHostedService {
  enable = true;
  name = "navidrome";
  datasets = [
    "navidrome"
    "navidrome/data"
  ];
}
