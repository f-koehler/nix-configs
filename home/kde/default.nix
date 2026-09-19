{ lib, pkgs, ... }:
{
  imports = [
    ./dolphin.nix
    ./kdeglobals.nix
    ./kglobalshortcuts.nix
    ./ki3.nix
    ./krunner.nix
    ./powerdevil.nix
  ];
  home.activation.rebuildKdeSycoca = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if command -v kbuildsycoca6 > /dev/null 2>&1; then
        $DRY_RUN_CMD kbuildsycoca6
      elif command -v kbuildsycoca5 > /dev/null 2>&1; then
        $DRY_RUN_CMD kbuildsycoca5
      fi
    ''
  );
  qt = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    kde.settings = {
      kcminputrc = {
        Mouse = {
          cursorTheme = "catppuccin-mocha-mauve-cursors";
        };
      };
      kded6rc = {
        "Module-gtkconfig" = {
          autoload = false;
        };
      };
    };
  };
}
