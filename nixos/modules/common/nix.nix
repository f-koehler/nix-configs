_: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["@wheel"];
      warn-dirty = false;
    };
    optimise.automatic = true;
  };
}
