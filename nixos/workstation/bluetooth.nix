{ lib, hasAnyTagOf, ... }: {
  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings = {
            General = {
              Experimental = true; # battery charge of connected devices
              FastConnectable = true;
            };
            Policy = {
              AutoEnable = true;
            };
          };
        };
      };
}
