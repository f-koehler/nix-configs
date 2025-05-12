{
  nodeConfig,
  stateVersion,
  ...
}:
{
  networking = {
    firewall = {
      allowedTCPPorts = [
        8443
        8080
        8843
        8880
        6789
      ];
      allowedUDPPorts = [
        3478
        10001
        1900
        5514
      ];
    };
  };
  containers.unifi = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "172.22.1.1";
    localAddress = "172.22.1.101";
    forwardPorts = [
      {
        containerPort = 8443;
        hostPort = 8443;
        protocol = "tcp";
      }
      {
        containerPort = 8080;
        hostPort = 8080;
        protocol = "tcp";
      }
      {
        containerPort = 8843;
        hostPort = 8843;
        protocol = "tcp";
      }
      {
        containerPort = 8880;
        hostPort = 8880;
        protocol = "tcp";
      }
      {
        containerPort = 6789;
        hostPort = 6789;
        protocol = "tcp";
      }
      {
        containerPort = 3478;
        hostPort = 3478;
        protocol = "udp";
      }
      {
        containerPort = 10001;
        hostPort = 10001;
        protocol = "udp";
      }
      {
        containerPort = 1900;
        hostPort = 1900;
        protocol = "udp";
      }
      {
        containerPort = 5514;
        hostPort = 5514;
        protocol = "udp";
      }
    ];
    bindMounts = {
      "/var/db/mongodb" = {
        hostPath = "/containers/unifi/db";
      };
    };
    config = _: {
      system.stateVersion = stateVersion;
      boot.isContainer = true;
      time.timeZone = nodeConfig.timeZone;
      nixpkgs.config.allowUnfree = true;
      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [
            8443
            8080
            8843
            8880
            6789
          ];
          allowedUDPPorts = [
            3478
            10001
            1900
            5514
          ];
        };
      };
      services = {
        unifi = {
          enable = true;
        };
      };
    };
  };
}

#   networking.firewall = {
#     allowedTCPPorts = [
#       8443
#       8080
#       8843
#       8880
#       6789
#     ];
#     allowedUDPPorts = [
#       3478
#       10001
#       1900
#       5514
#     ];
#   };
#   virtualisation.oci-containers.containers = {
#     unifi-db = {
#       image = "docker.io/mongo:7.0.20";
#       environmentFiles = [ "${config.sops.templates."unifi.env".path}" ];
#       networks = [ "unifi" ];
#       volumes = [
#         "/var/lib/unifi/db:/data/db:rw"
#         "${lib.getExe init-mongo}:/docker-entrypoint-initdb.d/init-mongo.sh:ro"
#       ];
#     };
#     unifi = {
#       image = "lscr.io/linuxserver/unifi-network-application:9.1.120";
#       dependsOn = [ "unifi-db" ];
#       environmentFiles = [ "${config.sops.templates."unifi.env".path}" ];
#       networks = [ "unifi" ];
#       ports = [
#         "8443:8443"
#         "3478:3478/udp"
#         "10001:10001/udp"
#         "8080:8080"
#         "1900:1900/udp"
#         "8843:8843"
#         "8880:8880"
#         "6789:6789"
#         "5514:5514/udp"
#       ];
#       volumes = [
#         "/var/lib/unifi/app:/config:rw"
#       ];
#     };
#   };
# }
