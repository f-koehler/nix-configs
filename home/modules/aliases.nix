{lib, pkgs, ...}: {
  home.shellAliases = {
    "cp" = "cp -i";
    "mv" = "mv -i";
    "rm" = "rm -i";
    "cat" = "bat --style=plain --paging=never";
    "tailscale" = lib.mkIf pkgs.stdenv.isDarwin "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    "open" = lib.mkIf pkgs.stdenv.isLinux "xdg-open";
  };
}
