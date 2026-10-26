{ pkgs, ... }: {
  imports = [ ./cpp.nix ];
  environment.systemPackages = [
    pkgs.prek
  ];
}
