_: {
  systemd = {
    services.beszel-agent = {
      environment = {
        EXTRA_FILESYSTEMS = "sda,sdb";
      };
    };
  };
}
