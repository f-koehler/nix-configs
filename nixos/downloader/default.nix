{
  username,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Singapore";

  users = {
    groups = {
      "${username}" = {};
      transmission.gid = lib.mkForce 985;
    };
    users = {
      "${username}" = {
        isNormalUser = true;
        extraGroups = ["wheel"];
      };
      transmission.uid = lib.mkForce 993;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    tailscale
    flood-for-transmission
  ];

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    performanceNetParameters = true;
    webHome = pkgs.flood-for-transmission;
    settings = {
      utp-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "*.*.*.*";
      download-dir = "/var/lib/transmission/Downloads/Complete";
      incomplete-dir = "/var/lib/transmission/Downloads/Incomplete";
    };
  };
  systemd = {
    mounts = [
      {
        description = "Download directory via virtiofs";
        what = "downloads";
        where = "/var/lib/transmission/Downloads";
        type = "virtiofs";
        wantedBy = ["multi-user.target"];
      }
    ];
    services.transmission.after = ["var-lib-transmission-Downloads.mount"];
  };
}
