{
  lib,
  pkgs,
  hasAnyTagOf,
  ...
}:
let
  # keepassxc is still built against Qt5, so it needs qt5ct's plugin and
  # QT_QPA_PLATFORMTHEME=qt5ct (the global value is qt6ct for Qt6 apps).
  keepassxcThemed = pkgs.symlinkJoin {
    name = "keepassxc-${pkgs.keepassxc.version}";
    paths = [ pkgs.keepassxc ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/keepassxc \
        --set QT_QPA_PLATFORMTHEME qt5ct \
        --prefix QT_PLUGIN_PATH : ${pkgs.libsForQt5.qt5ct}/${pkgs.qt5.qtbase.qtPluginPrefix}
    '';
    meta = pkgs.keepassxc.meta // {
      mainProgram = "keepassxc";
    };
  };
in
{
  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        programs.keepassxc = {
          enable = true;
          package = if pkgs.stdenv.hostPlatform.isLinux then keepassxcThemed else pkgs.keepassxc;
          autostart = pkgs.stdenv.hostPlatform.isLinux;
          settings = {
            Browser = {
              Enabled = true;
              UpdateBinaryPath = false;
            };
            GUI = {
              AdvancedSettings = true;
              ApplicationTheme = "classic";
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
      };
}
