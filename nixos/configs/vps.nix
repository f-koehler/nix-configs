{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  # environment.systemPackages = map lib.lowPrio [
  #   pkgs.curl
  #   pkgs.gitMinimal
  # ];

  networking.hostId = "168fda19";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAOMqatXS1rFhMRVr/7nSck8rMoIOP9s/uG+Z/B7qxkt fkoehler@Fabians-MacBook-Pro.local"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICerbBF7PR2EpPLyJUiNnvi2KJQY6dwN28kcg5P9Wgds fkoehler@fkt14"
  ];

  system.stateVersion = "24.11";
}