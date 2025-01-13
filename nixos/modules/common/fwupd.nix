{ pkgs, ... }:
{
  services.fwupd.enable = true;
  environment.systemPackages = with pkgs; [
    fwupd
  ];
}
