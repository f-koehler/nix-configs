_: let
  port = 8096;
in {
  containers.jellyfin = {
    ephemeral = true;
    autoStart = true;
    forwardPorts = [
      {
        hostPort = port;
        containerPort = port;
      }
    ];
    bindMounts = {
      "/var/lib/jellyfin" = {
        hostPath = "/containers/jellyfin/app";
        isReadOnly = false;
      };
      "/tank0" = {
        hostPath = "/media/tank0/media/";
        isReadOnly = true;
      };
      "/tank1" = {
        hostPath = "/media/tank1/media/";
        isReadOnly = true;
      };
    };
    allowedDevices = [
      {
        node = "/dev/dri/card1";
        modifier = "rw";
      }
      {
        node = "/dev/dri/renderD128";
        modifier = "rw";
      }
    ];
    config = {
      lib,
      pkgs,
      ...
    }: {
      nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
      };
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
          vaapiVdpau
          libvdpau-va-gl
          intel-compute-runtime
          vpl-gpu-rt
          intel-media-sdk
        ];
      };

      environment.systemPackages = [
        pkgs.jellyfin
        pkgs.jellyfin-web
        pkgs.jellyfin-ffmpeg
      ];
      services = {
        jellyfin = {
          enable = true;
          user = "jellyfin";
          group = "jellyfin";
        };
        resolved.enable = true;
      };
      users.users.jellyfin.extraGroups = ["render" "video"];
      networking.useHostResolvConf = lib.mkForce false;
    };
  };
  fileSystems = {
    "/containers/jellyfin/app" = {
      device = "rpool/jellyfin";
      fsType = "zfs";
    };
  };

  services = {
    nginx = {
      upstreams = {
        jellyfin = {
          servers = {
            "127.0.0.1:${toString port}" = {};
          };
        };
      };
      virtualHosts = {
        "media.fkoehler.xyz" = {
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
            "= /" = {
              return = "302 https://$host/web/";
            };
            "/" = {
              proxyPass = "http://jellyfin";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-Protocol $scheme;
                proxy_set_header X-Forwarded-Host $http_host;

                # Disable buffering when the nginx proxy gets very resource heavy upon streaming
                proxy_buffering off;
              '';
            };

            "= /web/" = {
              proxyPass = "http://jellyfin/web/index.html";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-Protocol $scheme;
                proxy_set_header X-Forwarded-Host $http_host;
              '';
            };

            "/socket" = {
              proxyPass = "http://jellyfin";
              extraConfig = ''
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-Protocol $scheme;
                proxy_set_header X-Forwarded-Host $http_host;
              '';
            };
          };
        };
      };
    };
  };
}
