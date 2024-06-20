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
    package = pkgs.samba4;
    enable = true;
    enableNmbd = true;
    openFirewall = true;
    nsswins = true;
    extraConfig = ''
      log level = 5
      server string = homeserver
      netbios name = homeserver
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
      media0 = {
        path = "/media/tank0/media";
        browseable = "yes";
        writeable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "force user" = "jellyfin";
        "force group" = "media";
        "valid users" = "fkoehler";
        "read list" = "fkoehler";
        "write list" = "fkoehler";
        comment = "Media on tank0";
      };
      media1 = {
        path = "/media/tank1/media";
        browseable = "yes";
        writeable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "force user" = "jellyfin";
        "force group" = "media";
        "valid users" = "fkoehler";
        "read list" = "fkoehler";
        "write list" = "fkoehler";
        comment = "Media on tank1";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    discovery = true;
  };
}
