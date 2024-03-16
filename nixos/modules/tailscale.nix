{config, ...}: {
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--ssh"
      "--hostname=${config.networking.hostName}"
      "--operator=fkoehler"
    ];
    authKeyFile = "/run/secrets/tailscale_key";
  };
}
