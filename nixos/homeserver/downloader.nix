{microvm, ...}: {
  # imports = [microvm.host];
  microvm = {
    autostart = ["downloader"];
    vms.downloader = {
      config = {
        microvm = {
          vcpu = 2;
          mem = 4096;
          interfaces = [
            {
              type = "tap";
              id = "vm-downloader";
              mac = "02:00:00:00:00:01";
            }
          ];
          shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
            }
            # expose authkey for tailscale here
          ];
        };
        networking.hostName = "homeserver-downloader";
        services = {
          openssh.enable = true;
          transmission = {
            enable = true;
            settings = {
              utp-enabled = true;
              rpc-bind-address = "0.0.0.0";
              openFirewall = true;
            };
          };
        };
        system.stateVersion = "24.05";
      };
    };
  };
}
