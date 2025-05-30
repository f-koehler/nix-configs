{ stateVersion, nodeConfig, ... }:
let
  ip = "172.22.1.103";
  port = 4533;
in
{
  containers.navidrome = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "172.22.1.1";
    localAddress = ip;
    bindMounts = {
      "/var/lib/navidrome" = {
        hostPath = "/containers/navidrome/app";
        isReadOnly = false;
      };
      "/soundtracks" = {
        hostPath = "/media/tank1/media/soundtracks";
        isReadOnly = true;
      };
    };
    config = _: {
      system.stateVersion = stateVersion;
      boot.isContainer = true;
      time.timeZone = nodeConfig.timeZone;
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ port ];
      };
      services.navidrome = {
        enable = true;
        settings = {
          Port = port;
          Address = "0.0.0.0";
          MusicFolder = "/soundtracks";
          DataFolder = "/data";
          BaseUrl = "https://music.fkoehler.xyz";
        };
      };
    };
  };
  services.nginx = {
    upstreams."navidrome" = {
      servers = {
        "${ip}:${toString port}" = { };
      };
    };
    virtualHosts."music.fkoehler.xyz" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/var/lib/acme/fkoehler.xyz/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/fkoehler.xyz/key.pem";
      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
      ];
      locations = {
        "/" = {
          proxyPass = "http://navidrome/";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_http_version 1.1;
            proxy_redirect http:// https://;
          '';
        };
      };
    };
  };
}
