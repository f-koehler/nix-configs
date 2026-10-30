_: {
  nix = {
    enable = true;
    daemon.enable = true;
    optimise = {
      automatic = true;
      dates = "weekly";
      persistent = true;
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "@wheel" ];
      # start garbage collection during builds if less than 5 GiB are left, until 20 GiB are free
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;
    };
  };
  # replaces nix.gc, also removes stale profile generations
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 30d";
    };
  };
}
