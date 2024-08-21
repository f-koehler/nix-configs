{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware.nix
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
    groups."${username}" = {};
    users."${username}" = {
      isNormalUser = true;
      linger = true;
      description = "Fabian Koehler";
      group = "${username}";
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
      boost
    ];
  };
}
