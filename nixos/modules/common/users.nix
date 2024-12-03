{
  lib,
  config,
  pkgs,
  username,
  ...
}: let
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAOMqatXS1rFhMRVr/7nSck8rMoIOP9s/uG+Z/B7qxkt fkoehler@mbp21"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICerbBF7PR2EpPLyJUiNnvi2KJQY6dwN28kcg5P9Wgds fkoehler@fkt14"
  ];
in {
  users = {
    groups."${username}" = {};
    users = {
      "${username}" = {
        isNormalUser = true;
        description = "Fabian Koehler";
        group = "${username}";
        extraGroups =
          ["wheel"]
          ++ (lib.optional config.virtualisation.libvirtd.enable) "libvirtd"
          ++ (lib.optional config.networking.networkmanager.enable) "networkmanager";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = sshKeys;
      };
      "root" = {
        openssh.authorizedKeys.keys = sshKeys;
      };
    };
  };
  programs = {
    zsh.enable = true;
  };
}
