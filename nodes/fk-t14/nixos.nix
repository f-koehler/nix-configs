_: {
  imports = [ ./disko.nix ];
  hardware.facter = {
    enable = true;
    reportPath = ./facter.json;
  };
  networking.hostName = "fk-t14";
}
