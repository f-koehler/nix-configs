{
  lib,
  isDarwin,
  ...
}:
lib.mkIf isDarwin {
  targets.darwin = {
    currentHostDefaults = {
      NSGlobalDomain = {
        AppleLanguages = [ "en-GB" ];
        AppleLocale = "en_GB";
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = true;
        AppleTemperatureUnit = "Celsius";
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.dock" = {
        size-immutable = true;
        tilesize = 64;
      };
      "com.apple.controlcenter" = {
        BatteryShowPercentage = true;
      };
    };
    search = "Google";
  };
}
