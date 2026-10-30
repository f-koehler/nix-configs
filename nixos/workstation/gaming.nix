{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.fk.gaming.enable = lib.mkEnableOption "steam, gamescope and mangohud";

  config = lib.mkIf config.fk.gaming.enable {
    programs = {
      gamescope = {
        enable = true;
        enableWsi = true;
        capSysNice = false;
      };
      steam = {
        enable = true;
        # provides mangoapp for `gamescope --mangoapp`
        extraPackages = [ pkgs.mangohud ];
      };
    };
  };
}
