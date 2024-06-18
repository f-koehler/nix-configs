{config, ...}: {
  sops = {
    secrets = {
      "security/acme/cloudflare/email" = {
        owner = config.services.nginx.user;
        inherit (config.services.nginx) group;
      };
      "security/acme/cloudflare/apiKey" = {
        owner = config.services.nginx.user;
        inherit (config.services.nginx) group;
      };
    };
    templates."cloudflare-credentials" = {
      owner = "acme";
      group = "acme";
      content = ''
        CLOUDFLARE_EMAIL="${config.sops.placeholder."security/acme/cloudflare/email"}"
        CLOUDFLARE_API_KEY="${config.sops.placeholder."security/acme/cloudflare/apiKey"}"
      '';
    };
  };
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
    "acme-finished-fkoehler.xyz.target"
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "signup@fkoehler.org";

    certs."fkoehler.xyz" = {
      dnsProvider = "cloudflare";
      domain = "*.fkoehler.xyz";
      extraDomainNames = ["fkoehler.xyz"];
      environmentFile = "${config.sops.templates."cloudflare-credentials".path}";
      inherit (config.services.nginx) group;
    };
  };
}
