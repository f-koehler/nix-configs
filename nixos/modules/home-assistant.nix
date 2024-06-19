_: {
  virtualisation.oci-containers.containers = {
    hass = {
      image = "ghcr.io/home-assistant/home-assistant:2024.6.1";
      extraOptions = [
        "--privileged"
        "--network=host"
      ];
      environment = {
        TZ = "Asia/Singapore";
      };
      volumes = [
        "/var/lib/hass:/config"
        "/run/dbus:/run/dbus:ro"
      ];
    };
  };
}
