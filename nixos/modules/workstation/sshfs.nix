{ pkgs, ... }:
let
  homedir = "/home/fkoehler";
  uid = 1000;
  gid = 986;
in
{
  environment.systemPackages = with pkgs; [ sshfs ];
  systemd = {
    mounts = [
      {
        description = "Mount media on tank0";
        what = "fkoehler@homeserver.corgi-dojo.ts.net:/media/tank0/media";
        where = "${homedir}/Public/media0";
        type = "fuse.sshfs";
        options = "_netdev,rw,nosuid,uid=${toString uid},gid=${toString gid},default_permissions,follow_symlinks,idmap=user,identityfile=${homedir}/.ssh/id_ed25519,debug,sshfs_debug,loglevel=debug";
        wantedBy = [
          "remote-fs.target"
          "multi-user.target"
        ];
        before = [ "remote-fs.target" ];
      }
    ];
    automounts = [
      {
        description = "Automount media on tank0";
        where = "${homedir}/Public/media0";
        wantedBy = [ "multi-user.target" ];
      }
    ];
  };
}
