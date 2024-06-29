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

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  system.stateVersion = "24.05";
}
