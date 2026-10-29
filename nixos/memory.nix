_: {
  # compressed swap in RAM, preferred over the swap partition/file on disk
  # (which is kept for hibernation)
  zramSwap.enable = true;

  # kill the cgroup causing memory pressure instead of freezing the desktop
  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };
}
