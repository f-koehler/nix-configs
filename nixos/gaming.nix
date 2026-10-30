{
  lib,
  pkgs,
  hasTag,
  ...
}:
{
  config = lib.mkIf (hasTag "gaming") {
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
