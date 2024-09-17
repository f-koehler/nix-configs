{
  pkgs,
  lib,
  stateVersion,
  system,
  ...
}: {
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
        user = "downloader";
        group = "downloader";
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
    users.downloader = {
      isNormalUser = lib.mkForce true;
      group = "downloader";
      extraGroups = ["wheel"];
      uid = lib.mkForce 993;
    };
    groups.downloader = {
      gid = lib.mkForce 985;
    };
  };
  nixpkgs.hostPlatform = lib.mkDefault system;
  system.stateVersion = stateVersion;
}
