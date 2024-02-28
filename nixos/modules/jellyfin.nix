{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "jellyfin";
      group = "jellyfin";
    };
    jellyseerr = {
      enable = true;
      openFirewall = true;
    };
    nginx = {
      upstreams."jellyfin" = {
        servers = {
          "127.0.0.1:8096" = {};
        };
      };
      virtualHosts."https".locations = {
        "/jellyfin" = {
          return = "302 $scheme://$host/jellyfin/";
        };
        "/jellyfin/" = {
          recommendedProxySettings = true;
          proxyPass = "http://jellyfin";
          extraConfig = ''
            proxy_pass_request_headers on;
            proxy_set_header Host $host;

            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $http_host;

            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $http_connection;

            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;
          '';
        };
      };
    };
  };
}
