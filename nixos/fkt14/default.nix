{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services = {
    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fkoehler = {
    isNormalUser = true;
    linger = true;
    description = "Fabian Koehler";
    extraGroups = [
      "libvirtd"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      cachix
      cmake
      conda
      devenv
      fftw
      gcc
      home-manager
      inshellisense
      ninja
      nix-index
      pkg-config
      rsync
      sops
      tailscale
    ];
  };
  programs = {
    fish.enable = true;
    virt-manager.enable = true;
    xfconf.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      neovim
      cifs-utils
      xwaylandvideobridge
    ];
  };
}
