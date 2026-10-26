_:
let
  disk1 = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7DNNU0Y804510K";
  disk2 = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7HENJ0Y224453Z";
in
{
  disko.devices = {
    disk = {
      main1 = {
        type = "disk";
        device = disk1;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "64G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
            root = {
              size = "100%";
            };
          };
        };
      };
      main2 = {
        type = "disk";
        device = disk2;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot-mirror";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "64G";
              content = {
                type = "swap";
                discardPolicy = "both";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f"
                  "-m"
                  "raid1"
                  "-d"
                  "raid1"
                  "/dev/disk/by-partlabel/disk-main1-root"
                ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
