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
        HostName = "10.1.128.107";
        User = "scbd3";
      };
      "Host scbd4" = {
        HostName = "10.1.128.102";
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
    };
  };
}
