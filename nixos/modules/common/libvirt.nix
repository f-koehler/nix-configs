{
  lib,
  config,
  pkgs,
  nodeConfig,
  ...
}:
lib.mkIf nodeConfig.virtualisation {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    virtiofsd
  ];
  programs.virt-manager.enable = nodeConfig.isWorkstation && config.virtualisation.libvirtd.enable;
}
