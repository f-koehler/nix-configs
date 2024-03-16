# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware/fkt14.nix

    ./modules/bluetooth.nix
    ./modules/collect-garbage.nix
    ./modules/distrobox.nix
    ./modules/libvirt.nix
    ./modules/locale.nix
    ./modules/plasma.nix
    ./modules/sound.nix
    ./modules/tailscale.nix
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fkoehler = {
    isNormalUser = true;
    description = "Fabian Koehler";
    extraGroups = [
      "libvirtd"
      "networkmanager"
      "wheel"
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
      kdePackages.plasma-browser-integration
      libreoffice-fresh
      nextcloud-client
      protonmail-bridge
      tailscale
      telegram-desktop
      thunderbird
      vlc
      vscode
      zotero
      virt-manager
      kdePackages.ktorrent
      sops
    ];
  };
  programs.fish.enable = true;
  services.flatpak.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
  ];

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
