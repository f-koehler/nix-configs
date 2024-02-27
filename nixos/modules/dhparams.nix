_: {
  security.dhparams = {
    enable = true;
    stateful = true;
    defaultBitSize = 8192;
    path = "/etc/ssl/certs/dhparams.pem";
  };
}
