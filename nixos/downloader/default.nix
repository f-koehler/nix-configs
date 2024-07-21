{
  username,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/vda";
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Singapore";

  environment.systemPackages = with pkgs; [
    neovim
    wget
    tailscale
    flood-for-transmission
  ];

  services = {
    transmission = {
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

  users = {
    mutableUsers = false;
    groups = {
      "${username}" = {};
      transmission.gid = lib.mkForce 985;
    };
    users = {
      "${username}" = {
        isNormalUser = true;
        group = "${username}";
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGmEylYhkqefvyTDMtNuRYZxCAbD2qcM2IHnPZ+NONYZ fkoehler@mbp2021"
        ];
      };
      transmission.uid = lib.mkForce 993;
    };
  };
}
