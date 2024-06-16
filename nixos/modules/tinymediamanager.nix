{config, ...}: {
  sops = {
    secrets."services/tinymediamanager/password" = {
      owner = "jellyfin";
      group = "jellyfin";
    };
    templates."tinymediamanager.env" = {
      owner = "jellyfin";
      group = "jellyfin";
      content = "PASSWORD=${config.sops.placeholder."services/tinymediamanager/password"}";
    };
  };
  virtualisation.oci-containers.containers = {
    tinymediamanager = {
      image = "docker.io/tinymediamanager/tinymediamanager:5.0.6";
      ports = [
        "5900:5900" # VNC port
        "0.0.0.0:4000:4000" # Webinterface
      ];
      environment = {
        ALLOW_DIRECT_VNC = "true";
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
        USER_ID = "993";
        GROUP_ID = "${toString config.users.groups.media.gid}";
      };
      environmentFiles = ["${config.sops.templates."tinymediamanager.env".path}"];
      volumes = [
        "/var/lib/tinymediamanager:/data:rw"
        "/media/tank1/media:/media/tank1"
      ];
    };
  };
  services.nginx = {
    upstreams.tinymediamanager = {
      servers = {
        "127.0.0.1:4000" = {};
      };
    };
    virtualHosts."tinymediamanager.fkoehler.xyz" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/var/lib/acme/fkoehler.xyz/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/fkoehler.xyz/key.pem";
      http2 = true;
      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
      ];
      locations = {
        "/" = {
          proxyPass = "http://tinymediamanager/";
          extraConfig = ''
            proxy_set_header   X-Real-IP $remote_addr;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header   Host $host;
            proxy_http_version 1.1;
            proxy_set_header   Upgrade $http_upgrade;
            proxy_set_header   Connection "upgrade";
          '';
        };
      };
    };
  };
}
