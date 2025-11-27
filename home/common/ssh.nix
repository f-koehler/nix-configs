{
  lib,
  nodeConfig,
  isLinux,
  ...
}:
lib.mkIf nodeConfig.isWorkstation {
  services.ssh-agent.enable = isLinux;
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
      "mbp2021" = {
        hostname = "mbp2021.corgi-dojo.ts.net";
        port = 22;
        user = "fkoehler";
      };
      "homeserver" = {
        hostname = "homeserver.corgi-dojo.ts.net";
        user = "fkoehler";
      };
      "desktop" = {
        hostname = "desktop.corgi-dojo.ts.net";
        user = "fkoehler";
      };
      "desktop-ubuntu" = {
        hostname = "desktop-ubuntu.corgi-dojo.ts.net";
        user = "fkoehler";
      };
      "scbd1" = {
        hostname = "10.1.128.101";
        user = "scbd1";
      };
      "scbd3" = {
        hostname = "10.1.128.104";
        user = "scbd3";
      };
      "scbd4" = {
        hostname = "10.1.128.102";
        user = "scbd4";
      };
    };
  };
}
