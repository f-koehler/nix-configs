{ lib, ... }:
{
  imports = [
    ./audiobookshelf.nix
    ./healthchecks.nix
    ./homepage.nix
    ./immich.nix
    ./karakeep.nix
    ./navidrome.nix
    ./paperless.nix
    ./stirling-pdf.nix
    ./vaultwarden.nix
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
  systemd.services."sanoid".serviceConfig = {
    Environment = [ "TZ=Asia/Singapore" ];
    DynamicUser = lib.mkForce false;
  };
  services.sanoid.enable = true;
  sops.secrets = {
    "services/tailscale/authKey" = {
    };
    "services/healthchecks/ping_key" = {
      owner = "sanoid";
      group = "sanoid";
    };
  };
}
