{ lib, hasAnyTagOf, ... }:
{
  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        services.flameshot = {
          enable = true;
          settings = {
            General = {
              disabledTrayIcon = true;
              showStartupLaunchMessage = false;
            };
          };
        };
      };
}
