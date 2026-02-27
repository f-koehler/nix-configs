{ lib, config, ... }:
lib.mkIf config.targets.genericLinux.gpu.enable {
  home.activation.nonNixOSGPU = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x /usr/sbin/restorecon ]; then
      $DRY_RUN_CMD /usr/bin/sudo /usr/sbin/restorecon -v "${config.targets.genericLinux.gpu.setupPackage}/lib/systemd/system/non-nixos-gpu.service"
    fi
    $DRY_RUN_CMD /usr/bin/sudo ${config.targets.genericLinux.gpu.setupPackage}/bin/non-nixos-gpu-setup
  '';
}
