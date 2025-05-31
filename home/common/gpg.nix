{
  pkgs,
  lib,
  isDarwin,
  isLinux,
  nodeConfig,
  ...
}:
{
  home.packages = with pkgs; [
    gnupg
  ];
  services.gpg-agent = lib.mkIf isLinux {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    defaultCacheTtl = 18000;
    grabKeyboardAndMouse = true;
    maxCacheTtl = 18000;
    pinentry.package =
      if isDarwin then
        pkgs.pinentry_mac
      else if nodeConfig.isWorkstation then
        pkgs.pinentry-qt
      else
        pkgs.pintentry-tty;
  };
}
