{
  pkgs,
  lib,
  isDarwin,
  isLinux,
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
    pinentryPackage = if isDarwin then pkgs.pinentry_mac else pkgs.pinentry-qt;
  };
}
