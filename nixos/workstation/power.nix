{ lib, hasTag, ... }: {
  config = lib.mkIf (hasTag "laptop") {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
  };
}
