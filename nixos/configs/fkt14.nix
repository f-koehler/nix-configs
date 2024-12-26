{
  pkgs,
  nodeConfig,
  ...
}: {
  imports = [
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
    plymouth = {
      enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
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
    groups."${nodeConfig.username}" = {};
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
        onlyoffice-desktopeditors
        imhex
        drawio
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
      xwaylandvideobridge
      boost
      ntfs3g
      exfatprogs
    ];
  };
}
