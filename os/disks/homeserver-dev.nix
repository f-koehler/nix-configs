{
  lib,
  nodeConfig,
  ...
}:
{
  disko.devices = {
    disk = {
      x = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "64M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
      y = {
        type = "disk";
        device = "/dev/vdb";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "64M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot-fallback";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
        # datasets = lib.mkMerge [
        #   {
        #     containers = {
        #       type = "zfs_fs";
        #       mountpoint = "/containers";
        #     };
        #   }
        #   (lib.mkIf nodeConfig.features.navidrome.enable {
        #     navidrome = {
        #       type = "zfs_fs";
        #       mountpoint = "/containers/navidrome";
        #     };
        #   })
        #   (lib.mkIf nodeConfig.features.audiobookshelf.enable {
        #     audiobookshelf = {
        #       type = "zfs_fs";
        #       mountpoint = "/containers/audiobookshelf";
        #     };
        #   })
        # ];
      };
    };
  };
}
