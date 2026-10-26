{ lib, ... }:
{
  imports = [ ./disko.nix ];
  hardware.facter = {
    enable = true;
    reportPath = ./facter.json;
  };
  networking.hostName = "fk-desktop";
  # facter's AMD iGPU module sets videoDrivers at normal priority, which
  # overrides nixos-hardware's mkDefault ["nvidia"]; add it back explicitly.
  services.xserver.videoDrivers = lib.mkAfter [ "nvidia" ];
}
