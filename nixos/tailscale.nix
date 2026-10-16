_: {
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--operator=fkoehler" ];
    openFirewall = true;
    useRoutingFeatures = "both";
  };
}
