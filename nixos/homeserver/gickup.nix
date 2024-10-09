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
      "services/gickup/forgejo_token" = {
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
              excludeorgs:
                - SpeQtral
                - Parallel-in-Time
                - flathub
                - majorpb
              filter:
                excludeforks: true
        destination:
          gitea:
            - token: "${config.sops.placeholder."services/gickup/forgejo_token"}"
              url: https://git.fkoehler.xyz
              user: fkoehler
              mirror:
                mirrorinterval: 8h
                enabled: false
              createorg: true
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
      # after = ["var-lib-gickup.mount" "tailscaled.service"];
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
