_: {
  systemd = {
    mounts = [
      {
        description = "Mount tank0 external USB disk";
        what = "/dev/disk/by-label/tank0";
        where = "/mnt/tank0";
        type = "exfat";
        wantedBy = [ "multi-user.target" ];
        options = "noatime,uid=fkoehler,gid=fkoehler,umask=0";
      }
    ];
    services = {
      samba-smbd.after = [
        "tank0.mount"
      ];
      samba-nmbd.after = [
        "tank0.mount"
      ];
    };
  };
}
