{lib, ...}: let
  port = 33333;
  domain = "youtube.fkoehler.xyz";
in {
  services = {
    invidious = {
      inherit port;
      inherit domain;

      enable = true;
      nginx = {
        enable = true;
      };
      http3-ytproxy.enable = true;
      sig-helper.enable = true;
    };
    nginx.virtualHosts.${domain} = {
      enableACME = lib.mkForce false; # we already have a wildcard certificate
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/var/lib/acme/fkoehler.xyz/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/fkoehler.xyz/key.pem";
    };
  };
}
