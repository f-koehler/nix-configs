{
  pkgs,
  nodeConfig,
  ...
}: {
  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/${nodeConfig.username}/Network/media1/soundtracks";
      network = {
        startWhenNeeded = true;
      };
    };
    mpd-mpris = {
      enable = true;
    };
  };
  home.packages = [
    pkgs.ncmpcpp
  ];
}
