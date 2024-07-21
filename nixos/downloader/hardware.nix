{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/3ca2cfef-8039-4bbb-a56a-da24e11a6a59";
  #   fsType = "ext4";
  # };

  # swapDevices = [
  #   {device = "/dev/disk/by-uuid/501d6be2-7789-4c63-a89e-561048fd9713";}
  # ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
