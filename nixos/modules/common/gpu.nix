{
  lib,
  pkgs,
  nodeConfig,
  ...
}:
let
  hasGpu = nodeConfig.gpus != [ ];
in
{
  hardware.graphics = {
    enable = hasGpu;
    extraPackages = lib.optionals (builtins.elem "intel" nodeConfig.gpus) [
      pkgs.intel-compute-runtime
      pkgs.ocl-icd
      pkgs.vpl-gpu-rt
      pkgs.intel-media-driver
    ];
  };
  environment.systemPackages = lib.optionals hasGpu [
    pkgs.clinfo
    pkgs.libva-utils
  ];
}
