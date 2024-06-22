{
  hostname,
  lib,
  isWorkstation,
  ...
}: {
  imports =
    [
      ./${hostname}
      ./modules/common
    ]
    ++ lib.optional isWorkstation ./modules/workstation;
  networking.hostName = hostname;
  sops.defaultSopsFile = ../secrets/${hostname}.yaml;
  system.stateVersion = "24.05";
}
