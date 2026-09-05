_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "Host scbd1" = {
        HostName = "10.1.128.104";
        User = "scbd1";
      };
      "Host scbd2" = {
        HostName = "10.1.128.103";
        User = "scbd2";
      };
      "Host scbd3" = {
        HostName = "192.168.2.177";
        User = "scbd3";
      };
      "Host scbd4" = {
        HostName = "192.168.2.216";
        User = "scbd4";
      };
      "Host scbd5" = {
        HostName = "10.1.245.52";
        User = "scbd5";
      };
      "Host scbd6" = {
        HostName = "10.1.250.159";
        User = "scbd6";
      };
      "Host scbd7" = {
        HostName = "10.1.178.70";
        User = "scbd7";
      };
      "Host dnsmasq" = {
        HostName = "10.1.3.1";
        User = "root";
      };
      "Host ogs3" = {
        User = "ogs3";
        HostName = "10.1.157.92";
      };
      "Host ogs2" = {
        User = "ogs2";
        HostName = "10.1.217.86";
      };
      "Host fk-temp27.speqtranet.com" = {
        ForwardAgent = "yes";
      };
      "Host homeserver" = {
        User = "fkoehler";
        HostName = "homeserver.corgi-dojo.ts.net";
      };
    };
  };
}
