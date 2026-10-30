_: {
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    limit = "100M";
  };
}
