{ inputs, ... }:
{
  imports = [
    "${inputs.nixos-hardware}/common/cpu/intel/raptor-lake"
    "${inputs.nixos-hardware}/common/gpu/intel/raptor-lake"
    "${inputs.nixos-hardware}/common/pc/ssd"
    ./disko.nix
  ];
  hardware.facter = {
    enable = true;
    reportPath = ./facter.json;
  };
  networking.hostName = "fk-t14";

  fk = {
    development.enable = true;
    podman.enable = true;
  };

  # Intel thermal management (complements power-profiles-daemon)
  services.thermald.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    # keep running with the lid closed when docked to an external monitor
    HandleLidSwitchDocked = "ignore";
  };
}
