{
  hostname,
  lib,
  isWorkstation,
  stateVersion,
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

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  system.stateVersion = stateVersion;
}
