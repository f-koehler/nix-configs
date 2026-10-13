{ pkgs, ... }: {
  programs.keepassxc = {
    enable = true;
    autostart = pkgs.stdenv.hostPlatform.isLinux;
    settings = {
      Browser = {
        Enabled = true;
        UpdateBinaryPath = false;
      };
      GUI = {
        AdvancedSettings = true;
        ApplicationTheme = "dark";
        CompactMode = true;
        HidePasswords = true;
        MinimizeOnClose = true;
        MinimizeOnStartup = true;
        MinimizeToTray = true;
        ShowTrayIcon = true;
        TrayIconAppearance = "monochrome-light";
      };
      SSHAgent = {
        Enabled = false;
      };
    };
  };
}
