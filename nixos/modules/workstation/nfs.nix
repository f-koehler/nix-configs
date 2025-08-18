_:
let
  ip = "100.104.64.71";
in
{
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;
  systemd.mounts =
    let
      commonMountOptions = {
        type = "nfs";
        mountConfig = {
          Options = "noatime";
        };
      };

    in
    [
      (
        commonMountOptions
        // {
          what = "${ip}:/media0";
          where = "/media/media0";
        }
      )

      (
        commonMountOptions
        // {
          what = "${ip}:/media0";
          where = "/media/media0";
        }
      )
    ];

  systemd.automounts =
    let
      commonAutoMountOptions = {
        wantedBy = [ "multi-user.target" ];
        automountConfig = {
          TimeoutIdleSec = "600";
        };
      };

    in

    [
      (commonAutoMountOptions // { where = "/media/media0"; })
      (commonAutoMountOptions // { where = "/media/media1"; })
    ];
}
