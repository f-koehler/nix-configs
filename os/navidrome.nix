{ myLib, ... }:
myLib.os.mkSelfHostedService {
  enable = true;
  name = "navidrome";
  datasets = [
    "data"
  ];
}
