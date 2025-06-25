_: {
  programs.firefox = {
    profiles.default = {
      settings = {
        # UI
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;

        "extensions.pocket.enabled" = false;
      };
    };
  };
}
