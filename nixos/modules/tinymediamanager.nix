{config, ...}: {
  sops = {
    secrets."services/tinymediamanager/password" = {
      owner = "jellyfin";
      group = "jellyfin";
    };
    templates."tinymediamanager.env" = {
      owner = "jellyfin";
      group = "jellyfin";
      content = "PASSWORD=${config.sops.placeholder."services/tinymediamanager/password"}";
    };
  };
  virtualisation.oci-containers.containers = {
    tinymediamanager = {
      image = "docker.io/tinymediamanager/tinymediamanager:5.0.6";
      ports = [
        "5900:5900" # VNC port
        "0.0.0.0:4000:4000" # Webinterface
      ];
      environment = {
        ALLOW_DIRECT_VNC = "true";
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
        USER_ID = "993";
        GROUP_ID = "${toString config.users.groups.media.gid}";
      };
      environmentFiles = ["${config.sops.templates."tinymediamanager.env".path}"];
      volumes = [
        "/var/lib/tinymediamanager:/data:rw"
        "/media/tank1/media:/media/tank1"
      ];
    };
  };
}
