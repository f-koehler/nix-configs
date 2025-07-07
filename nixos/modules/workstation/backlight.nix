{
  config,
  pkgs,
  nodeConfig,
  ...
}:
{
  environment.systemPackages = [
    pkgs.ddcutil
    pkgs.wluma
  ];
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    kernelModules = [
      "i2c-dev"
      "ddcci_backlight"
    ];
  };
  users.users.${nodeConfig.username}.extraGroups = [
    "video"
  ];
}
