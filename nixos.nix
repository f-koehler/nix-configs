{
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "desktop-nixos";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_SG.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  services.greetd = {
    enable = true;
  };
  services.displayManager = {
    noctalia-greeter.enable = true;
  };
  programs = {
    gamescope = {
      enable = true;
      enableWsi = true;
      capSysNice = false;
    };
    steam = {
      enable = true;
      # provides mangoapp for `gamescope --mangoapp`
      extraPackages = [ pkgs.mangohud ];
    };
    sway = {
      enable = true;
      xwayland.enable = true;
      extraOptions = [ "--unsupported-gpu" ];
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
    };
  };
  services.power-profiles-daemon.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.fkoehler = { };
  users.users.fkoehler = {
    isNormalUser = true;
    group = "fkoehler";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      tree
    ];

  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    htop

    # for neovim config
    gcc
    basedpyright
    clang-tools
    docker-language-server
    harper
    lua-language-server
    neocmakelsp
    ruff
    rust-analyzer
    statix
    taplo
    terraform-ls
    texlab
    tofu-ls
    zizmor
    nixfmt
    shfmt
    stylua
    terraform
    tex-fmt
    vscode-extensions.vadimcn.vscode-lldb.adapter
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
  services = {
    openssh = {
      enable = true;
      openFirewall = true;
    };
    tailscale = {
      enable = true;
      extraUpFlags = [ "--operator=fkoehler" ];
      openFirewall = true;
      useRoutingFeatures = "both";
    };
    gnome.gnome-keyring.enable = true;
    gnome.gcr-ssh-agent.enable = false;
  };
  programs.seahorse.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # battery charge of connected devices
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;

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
  system.stateVersion = "26.11"; # Did you read the comment?

}
