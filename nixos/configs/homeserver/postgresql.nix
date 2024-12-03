{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
    identMap = ''
      superuser_map      root      postgres
      superuser_map      postgres  postgres
      superuser_map      /^(.*)$   \1
    '';
  };

  fileSystems = {
    "/var/lib/postgresql" = {
      device = "rpool/postgresql";
      fsType = "zfs";
      neededForBoot = true;
    };
  };
}
