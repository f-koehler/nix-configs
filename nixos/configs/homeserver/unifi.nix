{
  config,
  lib,
  pkgs,
  ...
}:
let
  init-mongo = pkgs.writeShellScriptBin "init-mongo.sh" ''
    #!/bin/bash

    if which mongosh > /dev/null 2>&1; then
      mongo_init_bin='mongosh'
    else
      mongo_init_bin='mongo'
    fi
    "''${mongo_init_bin}" <<EOF
    use ''${MONGO_AUTHSOURCE}
    db.auth("''${MONGO_INITDB_ROOT_USERNAME}", "''${MONGO_INITDB_ROOT_PASSWORD}")
    db.createUser({
      user: "''${MONGO_USER}",
      pwd: "''${MONGO_PASS}",
      roles: [
        { db: "''${MONGO_DBNAME}", role: "dbOwner" },
        { db: "''${MONGO_DBNAME}_stat", role: "dbOwner" }
      ]
    })
    EOF
  '';
in
{
  sops = {
    secrets = {
      "services/unifi/db/passwords/root" = { };
      "services/unifi/db/passwords/unifi" = { };
    };
    templates."unifi.env" = {
      content = ''
        MONGO_INITDB_ROOT_USERNAME=root
        MONGO_INITDB_ROOT_PASSWORD=${config.sops.placeholder."services/unifi/db/passwords/root"}
        MONGO_USER=unifi
        MONGO_PASS=${config.sops.placeholder."services/unifi/db/passwords/unifi"}
        MONGO_DBNAME=unifi
        MONGO_AUTHSOURCE=admin
        MONGO_HOST=unifi-db
        MONGO_PORT=27017
        PUID=1000
        PGID=1000
        TZ=Asia/Singapore
      '';
    };
  };
  environment.systemPackages = [
    init-mongo
  ];
  systemd = {
    tmpfiles.settings.unifiDirs = {
      "/var/lib/unifi/db/".d = {
        mode = "700";
        user = "999";
        group = "999";
      };
      "/var/lib/unifi/app/".d = {
        mode = "700";
        user = "1000";
        group = "1000";
      };
    };
    services.create-unifi-network = {
      serviceConfig.Type = "oneshot";
      wantedBy = [
        "podman-unifi.service"
        "podman-unifi-db.service"
      ];
      script = ''
        ${pkgs.podman}/bin/podman network exists unifi || \
        ${pkgs.podman}/bin/podman network create unifi
      '';
      startLimitBurst = 50;
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      8443
      8080
      8843
      8880
      6789
    ];
    allowedUDPPorts = [
      3478
      10001
      1900
      5514
    ];
  };
  virtualisation.oci-containers.containers = {
    unifi-db = {
      image = "docker.io/mongo:7.0.19";
      environmentFiles = [ "${config.sops.templates."unifi.env".path}" ];
      networks = [ "unifi" ];
      volumes = [
        "/var/lib/unifi/db:/data/db:rw"
        "${lib.getExe init-mongo}:/docker-entrypoint-initdb.d/init-mongo.sh:ro"
      ];
    };
    unifi = {
      image = "lscr.io/linuxserver/unifi-network-application:9.1.120";
      dependsOn = [ "unifi-db" ];
      environmentFiles = [ "${config.sops.templates."unifi.env".path}" ];
      networks = [ "unifi" ];
      ports = [
        "8443:8443"
        "3478:3478/udp"
        "10001:10001/udp"
        "8080:8080"
        "1900:1900/udp"
        "8843:8843"
        "8880:8880"
        "6789:6789"
        "5514:5514/udp"
      ];
      volumes = [
        "/var/lib/unifi/app:/config:rw"
      ];
    };
  };
}
