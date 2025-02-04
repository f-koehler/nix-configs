{ pkgs, ... }:
{
  services.smartd = {
    enable = true;
    autodetect = true;
  };

  environment = {
    systemPackages = with pkgs; [
      smartmontools
    ];
  };
}
