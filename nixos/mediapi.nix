# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware/mediapi.nix
    ];

  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
    };
    raspberry-pi."4".fkms-3d.enable = true;
  };
  console.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.hostName = "mediapi";

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_SG.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;




  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.fkoehler = { };
  users.users.fkoehler = {
    isNormalUser = true;
    group = "fkoehler";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    htop
    wget
    tmux
    git

    config.services.samba.package
    cifs-utils
    nfstrace
    exfat
    exfatprogs
    mergerfs
    mergerfs-tools

    jellyfin
    jellyfin-web
    jellyfin-ffmpeg

    libraspberrypi
    raspberrypi-eeprom
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
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.audiobookshelf = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    port = 8097;
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = "--ssh --operator=fkoehler";
  };

  systemd.mounts = [
    {
      description = "Mount tank0 external USB disk";
      what = "/dev/disk/by-label/tank0";
      where = "/mnt/tank0";
      type = "exfat";
      wantedBy = [ "multi-user.target" ];
      options = "noatime,uid=fkoehler,gid=fkoehler,umask=0";
    }
  ];
  systemd.services.samba-smbd.after = [
    "tank0.mount"
  ];
  systemd.services.samba-nmbd.after = [
    "tank0.mount"
  ];

  services.samba = {
    package = pkgs.samba4Full;
    enable = true;
    enableNmbd = true;
    openFirewall = true;
    nsswins = true;
    extraConfig = ''
      log level = 5
      server string = mediapi
      netbios name = mediapi
      workgroup = WORKGROUP
      security = user

      create mask = 0664
      force create mode 0664
      directory mask = 0775
      force directory mode = 0775
      follow symlinks = yes
      
      guest account = nobody
      map to guest = bad user
      hosts allow = 100.64.0.0/10, 192.168.50., localhost, 127.0.0.1
    '';
    shares = {
      tank_0 = {
        path = "/mnt/tank0";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
        "force user" = "fkoehler";
        "force group" = "fkoehler";
        "write list" = "fkoehler";
        comment = "18TB USB Disk attached to mediapi";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    discovery = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
    enable = true;
    allowPing = true;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
