{config, ...}: {
  virtualisation.oci-containers.containers = {
    tiny-media-manager = {
      image = "docker.io/tinymediamanager/tinymediamanager:5.0.5";
      ports = [
        "5900:5900" # VNC port
        "4000:4000" # Webinterface
      ];
    };
  };
}
