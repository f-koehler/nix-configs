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
    recommendedOptimisation = true;
    clientMaxBodySize = "10G";
    sslDhparam = "${config.security.dhparams.params.nginx.path}";
    appendHttpConfig = ''
      proxy_headers_hash_max_size 2048;
      proxy_headers_hash_bucket_size 256;
    '';
  };
  networking.firewall.allowedTCPPorts = [80 443];
  systemd.services.nginx.after = [
    "dhparams-gen-nginx.service"
    "tailscale-cert.service"
  ];
}
