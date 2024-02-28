{pkgs, ...}: {
  services.gpg-agent =
    if pkgs.stdenv.isDarwin
    then {}
    else {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      defaultCacheTtl = 18000;
      grabKeyboardAndMouse = true;
      maxCacheTtl = 18000;
      pinentryFlavor = "qt";
    };
}
