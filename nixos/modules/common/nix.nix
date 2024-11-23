{outputs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["@wheel"];
    };
    optimise.automatic = true;
  };
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.additions
    ];
  };
}
