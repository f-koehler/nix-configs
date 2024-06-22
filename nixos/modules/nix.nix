{outputs, ...}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["@wheel"];
  };
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.additions
    ];
  };
}
