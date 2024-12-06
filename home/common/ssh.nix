{
  isWorkstation,
  lib,
  ...
}:
lib.mkIf isWorkstation {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "mbp2021" = {
        hostname = "mbp2021.corgi-dojo.ts.net";
        port = 22;
        user = "fkoehler";
      };
      "homeserver" = {
        hostname = "homeserver.corgi-dojo.ts.net";
        user = "fkoehler";
      };
      vps = {
        hostname = "194.61.28.200";
      };
      "fk-gha-runner-x64-01" = {
        hostname = "fk-gha-runner-x64-01.corgi-dojo.ts.net";
        user = "gha";
      };
      "fk-gha-runner-x64-02" = {
        hostname = "fk-gha-runner-x64-02.corgi-dojo.ts.net";
        user = "gha";
      };
    };
  };
}
