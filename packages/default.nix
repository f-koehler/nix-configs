pkgs: rec {
  sketchybar-lua = pkgs.callPackage ./sketchybar-lua {};
  sketchybar-config = pkgs.callPackage ./sketchybar-config {inherit sketchybar-lua;};
  sketchybar-plugins = pkgs.callPackage ./sketchybar-plugins {};
}
