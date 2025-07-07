{ lib, ... }:
{
  imports = [
    ./audiobookshelf.nix
    ./immich.nix
    ./navidrome.nix
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
