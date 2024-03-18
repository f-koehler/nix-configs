{pkgs, ...}: {
  users = {
    groups.tmm = {};
    users.tmm = rec {
      name = "tmm";
      isNormalUser = true;
      description = "Tiny Media Manager";
      autoSubUidGidRange = true;
      linger = true;
      home = "/home/${name}";
      shell = pkgs.bashInteractive;
      extraGroups = [
        "systemd-journal"
        "${name}"
      ];
    };
  };
  home-manager.users.tmm = {
    home = {
      stateVersion = "23.05";
      # TODO: fix hardcoded path
      file."/home/tmm/.config/containers/compose/projects/tiny-media-manager.env".text = ''
        COMPOSE_PROJECT_DIR=/etc/configs/nixos/modules/tiny-media-manager
        COMPOSE_FILE=docker-compose.yml
        COMPOSE_PATH_SEPARATOR=:
        COMPOSE_PROJECT_NAME=tiny-media-manager
      '';
    };
    programs.bash.enable = true;
  };
  systemd = {
    mounts = [
      {
        description = "Mount tank0 external USB disk (tmm)";
        what = "/dev/disk/by-label/tank0";
        where = "/home/tmm/tank0";
        type = "exfat";
        wantedBy = ["multi-user.target"];
        options = "noatime,uid=tmm,gid=tmm,umask=0";
      }
    ];
    # services = {
    #   samba-smbd.after = [
    #     "media-tank0.mount"
    #   ];
    #   samba-nmbd.after = [
    #     "media-tank0.mount"
    #   ];
    #   jellyfin.after = [
    #     "media-tank0.mount"
    #   ];
    # };
  };
  services = {
    nginx.upstreams."tmm" = {
      servers = {
        "127.0.0.1:4000" = {};
      };
    };
    nginx.virtualHosts."tmm.fkoehler.xyz" = {
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
          proxyPass = "http://tmm/";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Host $server_name;
            add_header Referrer-Policy "strict-origin-when-cross-origin";
          '';
        };
      };
    };
  };
}
