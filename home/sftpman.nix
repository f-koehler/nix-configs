{ config, ... }:
{
  programs.sftpman = {
    enable = true;
    defaultSshKey = "${config.home.homeDirectory}/.ssh/id_ed25519";
    mounts = {
      "media0" = {
        authType = "publickey";
        host = "homeserver";
        mountOptions = [ ];
        mountDestPath = "${config.home.homeDirectory}/Network/media0";
        mountPoint = "/media/tank0/media";
        user = "jellyfin";
      };
      "media1" = {
        authType = "publickey";
        host = "homeserver";
        mountOptions = [ ];
        mountDestPath = "${config.home.homeDirectory}/Network/media1";
        mountPoint = "/media/tank1/media";
        user = "jellyfin";
      };
    };
  };
}
