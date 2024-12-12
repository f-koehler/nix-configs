{nodeConfig, ...}: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [
      "--ssh"
      "--hostname=${nodeConfig.hostname}"
      "--operator=${nodeConfig.username}"
      "--accept-routes"
    ];
    useRoutingFeatures = "both";
  };
}
