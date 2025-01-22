{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    pkgs.beszel
  ];
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 45876 ];
  systemd = {
    tmpfiles.settings.beszelAgentDirs."/var/lib/beszel/agent/".d = {
      mode = "700";
      user = "root";
      group = "root";
    };
    services.beszel-agent = {
      name = "beszel-agent.service";
      description = "Beszel Agent";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      environment = {
        PORT = "45876";
        KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC44oyzZ8QBS90dViWEJClAt/i1v8UuPKX5qDYYkz+VK";
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "5";
        WorkingDirectory = "/var/lib/beszel/agent";
        ExecStart = "${lib.getExe' pkgs.beszel "beszel-agent"}";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
