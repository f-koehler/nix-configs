{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
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
        export PATH=/run/current-system/sw/bin:$PATH
        mkdir -p /etc/ssl/certs
        if [ ! -f /etc/ssl/certs/tailscale.crt ] || [ ! -f /etc/ssl/certs/tailscale.key ]; then
          tailscale cert --cert-file /etc/ssl/certs/tailscale.crt --key-file /etc/ssl/certs/tailscale.key "$(tailscale status --json | jq -r .Self.DNSName | sed -e 's/\.$//')"
        fi
      '';
      # chown nginx:nginx /etc/ssl/certs/tailscale.crt /etc/ssl/certs/tailscale.key
      # chmod 600 /etc/ssl/certs/tailscale.crt /etc/ssl/certs/tailscale.key
    };
  };
}
