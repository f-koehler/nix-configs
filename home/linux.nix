{ lib, config, ... }:
lib.mkIf config.targets.genericLinux.gpu.enable {
  home.activation.nonNixOSGPU = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD /usr/bin/sudo ${config.targets.genericLinux.gpu.setupPackage}/bin/non-nixos-gpu-setup
  '';
}
