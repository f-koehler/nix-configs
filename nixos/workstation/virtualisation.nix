{
  lib,
  pkgs,
  hasAnyTagOf,
  user,
  ...
}:
{
  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        environment.systemPackages = with pkgs; [
          dnsmasq
        ];
        programs.virt-manager.enable = true;
        networking.firewall.trustedInterfaces = [ "virbr0" ];
        users.users.${user}.extraGroups = [ "libvirtd" ];
        virtualisation.libvirtd = {
          enable = true;
        };
      };
}
