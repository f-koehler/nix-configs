{ inputs, user, ... }:
{
  # do not manage nix via nix-darwin, clashes with determinate nix
  nix.enable = false;

  imports = [
    inputs.mac-app-util.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
    ../tags.nix
    ./dock.nix
    ./homebrew.nix
  ];

  networking = {
    hostName = "fk-mbp21";
    localHostName = "fk-mbp21";
    computerName = "Fabian MacBook Pro 21";
  };
  system = {
    primaryUser = user;
    startup.chime = false;
    stateVersion = 7;
  };

  services = {
    tailscale.enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
