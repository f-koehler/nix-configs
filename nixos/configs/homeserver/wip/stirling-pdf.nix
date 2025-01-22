{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      stirling-pdf
    ];
  };
  users = {
    groups.stirlingpdf = { };
    users.stirlingpdf = {
      isSystemUser = true;
      group = "stirlingpdf";
      home = "/var/lib/stirlingpdf";
      createHome = true;
    };
  };
  systemd.services."stirling-pdf" = {
    description = "Stirling PDF";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.stirling-pdf}/bin/Stirling-PDF";
      Restart = "on-failure";
      User = "stirlingpdf";
      Group = "stirlingpdf";
    };
  };
}
