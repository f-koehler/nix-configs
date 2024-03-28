# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  outputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware/fkt14.nix

    ./modules/bluetooth.nix
    ./modules/collect-garbage.nix
    ./modules/firmware.nix
    ./modules/fstrim.nix
    ./modules/libvirt.nix
    ./modules/locale.nix
    ./modules/plasma.nix
    ./modules/sound.nix
    ./modules/tailscale.nix
    ./modules/wine.nix
  ];

  sops.defaultSopsFile = ../secrets/fkt14.yaml;

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    extraModprobeConfig = "options kvm_intel nested=1";
    initrd.luks.devices."luks-113a8b35-5611-48de-8a3a-a9f32fca8d4e".device = "/dev/disk/by-uuid/113a8b35-5611-48de-8a3a-a9f32fca8d4e";
  };

  networking.hostName = "fkt14"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fkoehler = {
    isNormalUser = true;
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
      firefox
      gimp
      gitFull
      inkscape
      jellyfin-media-player
      kate
      kdePackages.ktorrent
      kdePackages.plasma-browser-integration
      krdc
      libreoffice-fresh
      localsend
      nextcloud-client
      protonmail-bridge
      rsync
      sops
      tailscale
      telegram-desktop
      thunderbird
      vlc
      vscode
      zotero
      nix-index
      home-manager
      cachix
      distrobox
      evince

      poetry
      python311
      rye

      cmake
      gcc
      pkg-config
      ninja
      fftw

      super-productivity
    ];
  };
  programs.fish.enable = true;
  programs.virt-manager.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  services.xserver.libinput.enable = true;
  services.flatpak.enable = true;

  nixpkgs = {
    # Allow unfree packages
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.additions
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      neovim
      cifs-utils
      xwaylandvideobridge
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
