{
  config,
  username,
  ...
}: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [
      "--ssh"
      "--hostname=${config.networking.hostName}"
      "--operator=${username}"
      "--accept-routes"
    ];
    useRoutingFeatures = "both";
  };
}
