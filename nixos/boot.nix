{ pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # the ESP is only 1G, keep the number of kernels/initrds on it bounded
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
