{
  lib,
  pkgs,
  nodeConfig,
  config,
  ...
}:
let
  hasGpu = nodeConfig.gpus != [ ];
  hasNvidia = builtins.elem "nvidia" nodeConfig.gpus;
  hasIntel = builtins.elem "intel" nodeConfig.gpus;
in
{
  hardware.graphics = {
    enable = hasGpu;
    extraPackages = lib.optionals hasIntel [
      pkgs.intel-compute-runtime
      pkgs.ocl-icd
      pkgs.vpl-gpu-rt
      pkgs.intel-media-driver
    ];
  };
  environment.systemPackages =
    lib.optionals hasGpu [
      pkgs.clinfo
      pkgs.libva-utils
    ]
    ++ lib.optionals hasNvidia [ pkgs.nvtopPackages.full ];

  services.xserver.videoDrivers = lib.optionals hasNvidia [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    modesetting.enable = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
