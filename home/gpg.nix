{pkgs, ...}: {
  home.packages = with pkgs; [
    gnupg
  ];
  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    defaultCacheTtl = 18000;
    grabKeyboardAndMouse = true;
    maxCacheTtl = 18000;
    pinentryPackage =
      if pkgs.stdenv.isDarwin
      then pkgs.pinentry_mac
      else pkgs.pinentry-qt;
  };
}
