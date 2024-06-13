{
  pkgs,
  config,
  ...
}: {
  sops = {
    secrets."services/gickup/github_token" = {
      owner = "gickup";
      group = "gickup";
    };
    templates."gickup.yaml" = {
      owner = "gickup";
      group = "gickup";
      content = ''
        ---
        source:
          github:
            - token:
              user: f-koehler
        destination:
          local:
            - path: /var/lib/gickup
              structured: true
              bare: true
              token: "${config.sops.placeholder."services/gickup/github_token"}"
      '';
    };
  };
  environment.systemPackages = [pkgs.gickup];
  users = {
    groups.gickup = {};
    users.gickup = {
      isSystemUser = true;
      group = "gickup";
      home = "/var/lib/gickup";
      createHome = true;
    };
  };
  systemd.services.gickup = {
    description = "Backup git repositories with gickup";
    wantedBy = ["default.target"];
    after = ["var-lib-gickup.mount"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.gickup}/bin/gickup ${config.sops.templates."gickup.yaml".path}";
      User = "gickup";
      Group = "gickup";
    };
  };
}
