{ pkgs, ... }:

{
  home.packages = [
    pkgs.sshfs
  ];

  systemd.user = {
    mounts = {
      "home-fkoehler-Network-media0" = {
        Unit = {
          Description = "Mount tank0/media from homeserver";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Mount = {
          What = "fkoehler@homeserver.corgi-dojo.ts.net:/media/tank0/media";
          Where = "%h/Network/media0";
          Type = "fuse.sshfs";
          Options = "_netdev,users,idmap=user,IdentityFile=%h/.ssh/id_ed25519,default_permissions,ServerAliveInterval=15,ServerAliveCountMax=3,reconnect,debug";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
      "home-fkoehler-Network-media1" = {
        Unit = {
          Description = "Mount tank1/media from homeserver";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Mount = {
          What = "fkoehler@homeserver.corgi-dojo.ts.net:/media/tank1/media";
          Where = "%h/Network/media1";
          Type = "fuse.sshfs";
          Options = "_netdev,users,idmap=user,IdentityFile=%h/.ssh/id_ed25519,default_permissions,ServerAliveInterval=15,ServerAliveCountMax=3,reconnect,debug";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
    automounts = {
      "home-fkoehler-Network-media0" = {
        Unit = {
          Description = "Automount tank0/media from homeserver";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Automount = {
          Where = "%h/Network/media0";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
      "home-fkoehler-Network-media1" = {
        Unit = {
          Description = "Automount tank1/media from homeserver";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Automount = {
          Where = "%h/Network/media1";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };
}
