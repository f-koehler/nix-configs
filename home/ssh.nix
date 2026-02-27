_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      "scbd1" = {
        hostname = "10.1.128.104";
        user = "scbd1";
      };
      "scbd2" = {
        hostname = "10.1.128.103";
        user = "scbd2";
      };
      "scbd3" = {
        hostname = "10.1.128.107";
        user = "scbd3";
      };
      "scbd4" = {
        hostname = "10.1.128.102";
        user = "scbd4";
      };
      "scbd5" = {
        hostname = "10.1.245.52";
        user = "scbd5";
      };
      "scbd6" = {
        hostname = "10.1.250.159";
        user = "scbd6";
      };
      "scbd7" = {
        hostname = "10.1.178.70";
        user = "scbd7";
      };
      "dnsmasq" = {
        hostname = "10.1.3.1";
        user = "root";
      };
      "pve-beowulf-0" = {
        hostname = "10.1.206.113";
        user = "root";
      };
      "pve-beowulf-1" = {
        hostname = "10.1.142.246";
        user = "root";
      };
      "fk-gha-runner-x64-005" = {
        hostname = "10.1.218.102";
        user = "fkoehler";
      };
      "fk-gha-runner-x64-006" = {
        hostname = "10.1.255.49";
        user = "fkoehler";
      };
      "fk-gha-runner-x64-007" = {
        hostname = "10.1.242.35";
        user = "fkoehler";
      };
    };
  };
}
