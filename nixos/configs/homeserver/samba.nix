{ pkgs, ... }:
let
  mkDefaultShare =
    {
      path,
      comment ? "",
      ...
    }:
    {
      inherit path;
      inherit comment;
      browseable = "yes";
      writeable = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "force user" = "jellyfin";
      "force group" = "media";
      "valid users" = "fkoehler";
      "read list" = "fkoehler";
      "write list" = "fkoehler";
    };
in
{
  services = {
    samba-wsdd = {
      enable = true;
      openFirewall = true;
      discovery = true;
    };
    samba = {
      enable = true;
      openFirewall = true;
      package = pkgs.samba;
      nmbd.enable = true;
      nsswins = true;
      settings = {
        global = {
          "server string" = "homeserver";
          "netbios name" = "homeserver";
          workgroup = "WORKGROUP";
          security = "user";

          "create mask" = "0664";
          "force create mode" = "0664";
          "directory mask" = "0775";
          "force directory mode" = "0775";
          "follow symlinks" = "yes";
        };
        media0 = mkDefaultShare {
          path = "/media/tank0/media";
          comment = "Media on tank0";
        };
        media1 = mkDefaultShare {
          path = "/media/tank1/media";
          comment = "Media on tank1";
        };
      };
    };
  };
}
