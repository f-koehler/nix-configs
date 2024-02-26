_: {
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
    persistent = true;
  };
}
