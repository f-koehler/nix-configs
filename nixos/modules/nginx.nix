{config, ...}: {
  security.dhparams = {
    enable = true;
    stateful = true;
    defaultBitSize = 4096;
    params.nginx = {};
  };
  services.nginx = {
    enable = true;
    user = "nginx";
    group = "nginx";
    serverTokens = false;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    clientMaxBodySize = "10G";
    sslDhparam = "${config.security.dhparams.params.nginx.path}";
  };
  networking.firewall.allowedTCPPorts = [80 443];
  systemd.services.nginx.after = [
    "dhparams-gen-nginx.service"
    "tailscale-cert.service"
  ];
}
