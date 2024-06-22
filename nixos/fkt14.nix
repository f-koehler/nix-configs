{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./fkt14

    ./modules/bluetooth.nix
    ./modules/collect-garbage.nix
    ./modules/firmware.nix
    ./modules/fstrim.nix
    ./modules/fwupd.nix
    ./modules/libvirt.nix
    ./modules/locale.nix
    ./modules/netdata.nix
    ./modules/nix.nix
    ./modules/plasma.nix
    ./modules/sound.nix
    ./modules/ssh.nix
    ./modules/sway.nix
    ./modules/tailscale.nix
    ./modules/wine.nix
    ./modules/nix-ld.nix
  ];

  sops.defaultSopsFile = ../secrets/fkt14.yaml;

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "fkt14"; # Define your hostname.
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

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fkoehler = {
    isNormalUser = true;
    linger = true;
    description = "Fabian Koehler";
    extraGroups = [
      "libvirtd"
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      bitwarden-desktop
      cachix
      chromium
      cmake
      conda
      devenv
      distrobox
      evince
      fftw
      firefox
      gcc
      gimp
      gitFull
      gnome.nautilus
      home-manager
      inkscape
      inshellisense
      jellyfin-media-player
      kate
      kdePackages.plasma-browser-integration
      krdc
      libreoffice-fresh
      localsend
      nextcloud-client
      ninja
      nix-index
      pkg-config
      protonmail-bridge
      rsync
      sops
      super-productivity
      tailscale
      telegram-desktop
      thunderbird
      vlc
      vscode
      zotero
      transmission-remote-gtk
      xfce.thunar
      xfce.thunar-volman
      gvfs
    ];
  };
  programs = {
    fish.enable = true;
    virt-manager.enable = true;
    xfconf.enable = true;
  };
  services = {
    libinput.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      neovim
      cifs-utils
      xwaylandvideobridge
    ];
  };

  system.stateVersion = "23.11";
}
