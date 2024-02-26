{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    coreutils
    gnused
    jq
    tailscale
  ];
  systemd.services = {
    tailscale-cert = {
      description = "Fetch tailscale SSL cert.";
      wants = [ "tailscaled.service" ];
      after = [ "tailscaled.service" ];
      serviceConfig = {
        Type = "oneshot";
      };
      wantedBy = [ "default.target" ];
      script = ''
        #!/bin/sh
        set -euf -o pipefail
        ${pkgs.coreutils}/bin/mkdir -p /etc/ssl/certs
        if [ ! -f /etc/ssl/certs/tailscale.crt ] || [ ! -f /etc/ssl/certs/tailscale.key ]; then
          ${pkgs.tailscale}/bin/tailscale cert --cert-file /etc/ssl/certs/tailscale.crt --key-file /etc/ssl/certs/tailscale.key "$(${pkgs.tailscale}/bin/tailscale status --json | ${pkgs.jq}/bin/jq -r .Self.DNSName | ${pkgs.gnused}/bin/sed -e 's/\.$//')"
        fi
        ${pkgs.coreutils}/bin/chown ${config.services.nginx.user}:${config.services.nginx.group} /etc/ssl/certs/tailscale.crt /etc/ssl/certs/tailscale.key
        ${pkgs.coreutils}/bin/chmod 600 /etc/ssl/certs/tailscale.crt /etc/ssl/certs/tailscale.key
      '';
    };
  };
}
