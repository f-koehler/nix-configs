{config, ...}: {
  sops.secrets."services/tailscale/authKey" = {
    sopsFile = ../../secrets/common.yaml;
    restartUnits = [
      "tailscaled.service"
      "tailscaled-autoconnect.service"
    ];
  };
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--ssh"
      "--hostname=${config.networking.hostName}"
      "--operator=fkoehler"
      "--accept-routes"
    ];
    authKeyFile = config.sops.secrets."services/tailscale/authKey".path;
  };
  networking.firewall.checkReversePath = "loose";
}
