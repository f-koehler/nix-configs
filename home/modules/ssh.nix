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
        hostname = "100.101.7.60";
        port = 22;
        user = "fkoehler";
      };
      "vps" = {
        hostname = "100.74.108.18";
        port = 20257;
        user = "fkoehler";
      };
      "homeserver" = {
        hostname = "100.88.7.127";
        user = "fkoehler";
      };
      "fk-gha-runner-x64-01" = {
        hostname = "10.1.128.202";
        user = "gha";
      };
      "fk-gha-runner-x64-02" = {
        hostname = "10.1.128.203";
        user = "gha";
      };
    };
  };
}
