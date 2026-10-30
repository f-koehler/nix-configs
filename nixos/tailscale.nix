{ lib, user, ... }: {
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--operator=${user}" ];
    openFirewall = true;
    # servers override this, e.g. with "server"
    useRoutingFeatures = lib.mkDefault "both";
  };
  networking.firewall = {
    # required for subnet routers/exit nodes, strict rp_filter drops the routed traffic
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
  };
}
