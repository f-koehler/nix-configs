{ lib, ... }:
{
  imports = [
    ./audiobookshelf.nix
    ./homepage.nix
    ./immich.nix
    ./navidrome.nix
    ./paperless.nix
    ./stirling-pdf.nix
  ];

  users = {
    groups.sanoid = { };
    users.sanoid = {
      group = "sanoid";
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/sanoid";
    };
  };
  systemd.services."sanoid".serviceConfig.DynamicUser = lib.mkForce false;
  services.sanoid.enable = true;
  sops.secrets = {
    "services/tailscale/authKey" = {
    };
  };
}
