{ user, ... }: {
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--operator=${user}" ];
    openFirewall = true;
    useRoutingFeatures = "both";
  };
}
