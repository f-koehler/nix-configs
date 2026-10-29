{ inputs, lib, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/common/cpu/amd"
    "${inputs.nixos-hardware}/common/cpu/amd/pstate.nix"
    "${inputs.nixos-hardware}/common/gpu/nvidia/blackwell"
    "${inputs.nixos-hardware}/common/hidpi.nix"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./disko.nix
  ];
  hardware.facter = {
    enable = true;
    reportPath = ./facter.json;
  };
  networking.hostName = "fk-desktop";
  # facter's AMD iGPU module sets videoDrivers at normal priority, which
  # overrides nixos-hardware's mkDefault ["nvidia"]; add it back explicitly.
  services.xserver.videoDrivers = lib.mkAfter [ "nvidia" ];
}
