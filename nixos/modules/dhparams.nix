{config, ...}: {
  security.dhparams = {
    enable = true;
    stateful = true;
    defaultBitSize = 8192;
    path = "/etc/ssl/certs/dhparams.pem";
  };
  systemd.services.nginx.after = ["dhparams-init.service"];
  services.nginx.sslDhparam = "${config.security.dhparams.path}";
}
