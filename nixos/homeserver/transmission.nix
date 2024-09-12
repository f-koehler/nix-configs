{
  pkgs,
  lib,
  ...
}: {
  microvm.vms.transmission = {
    inherit pkgs;
    config = {
      microvm.shares = [
        {
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "ro-store";
          proto = "virtiofs";
        }
      ];
      services = {
        transmission = {
          enable = true;
          package = pkgs.transmission_4;
          settings = {
            utp-enabled = true;
            rpc-bind-address = "0.0.0.0";
            peer-limit-global = 2048;
            peer-limit-per-torrent = 256;
            incomplete-dir-enabled = true;
            incomplete-dir = "/downloads/incomplete";
            download-dir = "/downloads/complete";
          };
          performanceNetParameters = true;
        };
        tailscale = {
          enable = true;
          openFirewall = true;
          interfaceName = "tailscale-downloader";
          extraUpFlags = [
            "--ssh"
            "--hostname=downloader"
            "--operator=transmission"
            "--accept-routes"
          ];
          useRoutingFeatures = "both";
        };
        resolved.enable = true;
      };
      users = {
        users.transmission.uid = lib.mkForce 993;
        groups.transmission.gid = lib.mkForce 985;
      };
    };
  };
}
