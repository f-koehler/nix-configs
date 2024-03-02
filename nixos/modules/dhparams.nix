{config, ...}: {
  security.dhparams = {
    enable = true;
    stateful = true;
    defaultBitSize = 4096;
    params.nginx = {};
  };
  systemd.services.nginx.after = ["dhparams-gen-nginx.service"];
  services.nginx.sslDhparam = "${config.security.dhparams.params.nginx.path}";
}
