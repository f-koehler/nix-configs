# Base shared by every NixOS node (workstations and servers). Anything that
# only makes sense with a desktop session lives in ./workstation.
{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.determinate.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    ../tags.nix
    ./development.nix
    ./memory.nix
    ./networking.nix
    ./nix.nix
    ./podman.nix
    ./ssh.nix
    ./tailscale.nix
    ./user.nix
  ];

  time.timeZone = "Asia/Singapore";
  i18n.defaultLocale = "en_SG.UTF-8";
  # nodes with an existing install override this to the release they were installed with
  system.stateVersion = lib.mkDefault "26.11"; # Did you read the comment?

  services.envfs.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    killall
    gptfdisk
    e2fsprogs
  ];
}
