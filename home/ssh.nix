{config, ...}: {
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
      "osmc" = {
        hostname = "100.82.94.54";
        port = 22;
        user = "osmc";
      };
      "zoq45" = {
        hostname = "100.107.23.113";
        port = 22;
        user = "fkoehler";
      };
      "fk-dev-x86-01" = {
        hostname = "ec2-18-140-197-34.ap-southeast-1.compute.amazonaws.com";
        user = "ubuntu";
        identityFile = "${config.home.homeDirectory}/.ssh/fk.pem";
      };
      "fk-dev-x86-02" = {
        hostname = "ec2-13-214-148-20.ap-southeast-1.compute.amazonaws.com";
        user = "ubuntu";
        identityFile = "${config.home.homeDirectory}/.ssh/fk.pem";
      };
    };
  };
}
