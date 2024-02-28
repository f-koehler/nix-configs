_: {
  services = {
    audiobookshelf = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
      port = 8097;
      user = "audiobookshelf";
      group = "audiobookshelf";
    };
    nginx = {
      upstreams."audiobookshelf" = {
        servers = {
          "127.0.0.1:8097" = {};
        };
      };
      virtualHosts."https".locations = {
        "/audiobookshelf" = {
          return = "302 $scheme://$host/audiobookshelf/";
        };
        "/audiobookshelf/" = {
          proxyPass = "http://audiobookshelf";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            proxy_http_version 1.1;
          '';
        };
      };
    };
  };
}
