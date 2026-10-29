{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/common/cpu/intel/raptor-lake"
    "${inputs.nixos-hardware}/common/gpu/intel/raptor-lake"
    "${inputs.nixos-hardware}/common/pc"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./disko.nix
  ];
  hardware.facter = {
    enable = true;
    reportPath = ./facter.json;
  };
  networking.hostName = "fk-t14";
}
