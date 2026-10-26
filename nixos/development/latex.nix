{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.texliveFull
    pkgs.texlab
    pkgs.tectonic
  ];
}
