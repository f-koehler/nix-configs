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
      # "/var/db/mongodb" = {
      #   hostPath = "/containers/unifi/db";
      # };
    };
    config =
      { pkgs, ... }:
      {
        system.stateVersion = stateVersion;
        boot.isContainer = true;
        time.timeZone = nodeConfig.timeZone;
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = [ pkgs.mongodb-tools ];
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
