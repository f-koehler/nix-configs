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
    virtualHosts."https" = {
      serverName = "${config.networking.hostName}.corgi-dojo.ts.net";
      http2 = true;
      kTLS = true;
      forceSSL = true;
      sslCertificate = "/etc/ssl/certs/tailscale.crt";
      sslCertificateKey = "/etc/ssl/certs/tailscale.key";
      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
        {
          addr = "[::]";
          port = 443;
          ssl = true;
        }
      ];
      extraConfig = ''
        proxy_headers_hash_max_size 512;
        proxy_headers_hash_bucket_size 128;
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];
  systemd.services.nginx.after = [
    "dhparams-gen-nginx.service"
    "tailscale-cert.service"
  ];
}
