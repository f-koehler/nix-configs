_: {
  # do not manage nix via nix-darwin, clashes with determinate nix
  nix.enable = false;

  imports = [
    ./homebrew.nix
  ];

  networking = {
    hostName = "fk-mbp21";
    localHostName = "fk-mbp21";
    computerName = "Fabian MacBook Pro 21";
  };
  system = {
    primaryUser = "fkoehler";
    startup.chime = false;
    stateVersion = 7;
  };

  services = {
    tailscale.enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
