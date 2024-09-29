{
  config,
  username,
  ...
}: {
  sops = {
    secrets = {
      "services/samba/password" = {
        owner = "${username}";
        group = "${username}";
        sopsFile = ../../../secrets/common.yaml;
      };
    };
    templates."samba-credentials" = {
      owner = "${username}";
      group = "${username}";
      content = ''
        username=${username}
        password=${config.sops.placeholder."services/samba/password"}
      '';
    };
  };
  systemd = {
    mounts = [
      {
        type = "cifs";
        what = "//100.64.220.85/media0";
        where = "${config.users.users.${username}.home}/Network/media0";
        options = "_netdev,rw,credentials=${config.sops.templates."samba-credentials".path},workgroup=workgroup,iocharset=utf8,uid=${username},gid=${username}";
        wantedBy = ["multi-user.target"];
      }
      {
        type = "cifs";
        what = "//100.64.220.85/media1";
        where = "${config.users.users.${username}.home}/Network/media1";
        options = "_netdev,rw,credentials=${config.sops.templates."samba-credentials".path},workgroup=workgroup,iocharset=utf8,uid=${username},gid=${username}";
        wantedBy = ["multi-user.target"];
      }
    ];
    automounts = [
      {
        where = "${config.users.users.${username}.home}/Network/media0";
        wantedBy = ["multi-user.target"];
      }
      {
        where = "${config.users.users.${username}.home}/Network/media1";
        wantedBy = ["multi-user.target"];
      }
    ];
  };
}
