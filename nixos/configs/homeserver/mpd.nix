{config, ...}: {
  services.mpd = {
    enable = true;
    startWhenNeeded = true;
    network.listenAddress = "100.64.220.85";
    musicDirectory = "/media/tank1/media/soundtracks";
  };
  networking.firewall.interfaces.${config.service.tailscale.interfaceName}.allowedTCPPorts = [
    config.services.mpd.network.port
  ];
}
