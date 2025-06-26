{
  pkgs,
  nodeConfig,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };
  };

  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services = {
    printing.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    groups."${nodeConfig.username}" = { };
    users."${nodeConfig.username}" = {
      linger = true;
      packages = with pkgs; [
        cachix
        cmake
        conda
        devenv
        fftw
        gcc
        home-manager
        ninja
        nix-index
        pkg-config
        rsync
        sops
        tailscale
        usbutils
        imhex
        anki
        cudaPackages.nsight_compute
        signal-desktop
      ];
    };
  };
  programs = {
    xfconf.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      neovim
      cifs-utils
      kdePackages.xwaylandvideobridge
      boost
      ntfs3g
      exfatprogs
    ];
  };

  services.cloudflare-warp.enable = true;
}
