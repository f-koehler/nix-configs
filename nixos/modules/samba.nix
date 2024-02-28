{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    config.services.samba.package
    cifs-utils
    nfstrace
  ];

  services.samba = {
    package = pkgs.samba4Full;
    enable = true;
    enableNmbd = true;
    openFirewall = true;
    nsswins = true;
    extraConfig = ''
      log level = 5
      server string = mediapi
      netbios name = mediapi
      workgroup = WORKGROUP
      security = user

      create mask = 0664
      force create mode 0664
      directory mask = 0775
      force directory mode = 0775
      follow symlinks = yes

      guest account = nobody
      map to guest = bad user
      hosts allow = 100.64.0.0/10, 192.168.50., localhost, 127.0.0.1
    '';
    shares = {
      tank_0 = {
        path = "/mnt/tank0";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
        "force user" = "fkoehler";
        "force group" = "fkoehler";
        "write list" = "fkoehler";
        comment = "18TB USB Disk attached to mediapi";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    discovery = true;
  };
}
