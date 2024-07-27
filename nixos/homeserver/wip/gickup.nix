{
  pkgs,
  config,
  ...
}: {
  sops = {
    secrets = {
      "services/gickup/github_token" = {
        owner = "gickup";
        group = "gickup";
      };
      "services/gickup/bitbucket/password" = {
        owner = "gickup";
        group = "gickup";
      };
      "services/gickup/bitbucket/sshkey" = {
        owner = "gickup";
        group = "gickup";
      };
    };
    templates."gickup.yaml" = {
      owner = "gickup";
      group = "gickup";
      content = ''
        ---
        source:
          github:
            - token: "${config.sops.placeholder."services/gickup/github_token"}"
              user: f-koehler
              exclude:
                - nixpkgs
                - LibreELEC.tv
          bitbucket:
            - url: https://bitbucket.org
              user: f-koehler
              username: f-koehler
              sshkey: ${config.sops.secrets."services/gickup/bitbucket/sshkey".path}
              password: ${config.sops.placeholder."services/gickup/bitbucket/password"}
        destination:
          local:
            - path: /var/lib/gickup
              structured: true
              bare: true
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
  systemd = {
    services.gickup = {
      description = "git backups with gickup";
      wantedBy = ["multi-user.target"];
      after = ["var-lib-gickup.mount" "tailscaled.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.gickup}/bin/gickup ${config.sops.templates."gickup.yaml".path}";
        User = "gickup";
        Group = "gickup";
      };
    };
    timers.gickup = {
      description = "Periodic git backups with gickup";
      timerConfig = {
        Unit = "gickup.service";
        OnCalendar = "daily";
      };
    };
  };
}
