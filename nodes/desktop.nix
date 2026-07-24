_: {
  home = {
    username = "fkoehler";
    homeDirectory = "/home/fkoehler";
  };
  programs.nvibrant = {
    enable = true;
  };
  targets = {
    genericLinux = {
      enable = true;
      gpu = {
        enable = true;
        nvidia = {
          enable = true;
          sha256 = "sha256-MDSgVLtM33dS/43CclZMsQVROAS/9TU4lFkBsWyndGM=";
          version = "610.43.02";
        };
      };
    };
  };
  # home-manager's GPU module calls .override { kernel = null; } but nixpkgs removed `kernel` from nvidia generic.nix in ebc08544
  nixpkgs.overlays = [
    (_: prev: {
      linuxPackages = prev.linuxPackages.extend (
        _: lprev: {
          nvidiaPackages = lprev.nvidiaPackages // {
            mkDriver =
              driverArgs:
              let
                base = lprev.nvidiaPackages.mkDriver driverArgs;
                origOverride = base.override;
              in
              base
              // {
                override = overrideArgs: origOverride (builtins.removeAttrs overrideArgs [ "kernel" ]);
              };
          };
        }
      );
    })
  ];
}
