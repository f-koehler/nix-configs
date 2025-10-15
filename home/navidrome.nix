{ stateVersion, ... }:
{
  home = {
    username = "navidrome";
    homeDirectory = "/home/navidrome";
    inherit stateVersion;
  };
  programs.home-manager.enable = true;
  services = {
    podman = {
      containers = {
        navidrome = {
          autoStart = true;
          autoUpdate = false;
          description = "Navidrome Music Server";
          image = "docker.io/deluan/navidrome:0.58.0";
          network = "navidrome";
        };
        tailscale = {
          autoStart = true;
          autoUpdate = false;
          description = "Tailscale mesh network";
          image = "docker.io/tailscale/tailscale:v1.88.2";
          network = "tailscale";
        };
      };
      networks.navidrome = {
        autoStart = true;
        description = "Navidrome Music Server Network";
        internal = true;
      };
    };
  };
}
