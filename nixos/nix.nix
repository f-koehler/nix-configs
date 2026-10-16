_: {
  nix = {
    enable = true;
    daemon.enable = true;
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
    };
    optimise = {
      automatic = true;
      dates = "weekly";
      persistent = true;
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;
}
