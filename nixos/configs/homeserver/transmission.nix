{
  config,
  ...
}:
{
  sops = {
    secrets = {
      "services/tailscale/authKey" = {
        sopsFile = ../../../secrets/common.yaml;
      };
      "services/transmission/password" = { };
    };
    templates."transmission.env" = {
      content = ''
        TS_ACCEPT_DNS=true
        TS_AUTHKEY=${config.sops.placeholder."services/tailscale/authKey"}
        TS_AUTH_ONCE=true
        TS_EXTRA_ARGS=--exit-node=100.110.81.102
        TS_HOSTNAME=transmission
        TS_STATE_DIR=/var/lib/tailscale
        TS_USERSPACE=false

        PUID=1000
        PGID=1000
        TZ=Asia/Singapore
        USER=fkoehler
        PASSWORD=${config.sops.placeholder."services/transmission/password"}
      '';
    };
  };
  systemd = {
    tmpfiles.settings.transmissionDirs = {
      "/var/lib/transmission/tailscale/".d = {
      };
      "/var/lib/transmission/app".d = {
        mode = "700";
        user = "1000";
        group = "1000";
      };
    };
  };
  virtualisation.oci-containers.containers = {
    transmission-tailscale = {
      image = "docker.io/tailscale/tailscale:v1.78.3";
      environmentFiles = [ "${config.sops.templates."transmission.env".path}" ];
      volumes = [
        "/var/lib/transmission/tailscale:/var/lib/tailscale:rw"
      ];
      capabilities = {
        NET_ADMIN = true;
      };
      devices = [
        "/dev/net/tun:/dev/net/tun"
      ];
    };
    transmission = {
      image = "lscr.io/linuxserver/transmission:4.0.6";
      dependsOn = [ "transmission-tailscale" ];
      environmentFiles = [ "${config.sops.templates."transmission.env".path}" ];
      extraOptions = [ "--network=container:transmission-tailscale" ];
      ports = [
        "9091:9091"
        "51413:51413"
        "51413:51413/udp"
      ];
      volumes = [
        "/var/lib/transmission/app:/config:rw"
      ];
    };
  };
}
