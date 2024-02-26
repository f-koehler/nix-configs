{ config, ... }: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = "--ssh --operator=fkoehler --hostname=${config.networking.hostName}";
  };
}
