{ nodeConfig, lib, ... }:
let
  hasPlasma = builtins.elem "plasma" nodeConfig.desktops;
in
{
  catppuccin.kvantum.enable = false;
  qt = lib.mkIf hasPlasma {
    enable = !hasPlasma;

    # set theme/style to kvantum for catppuccin
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };
}
