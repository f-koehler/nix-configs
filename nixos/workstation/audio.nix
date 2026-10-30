{ lib, hasAnyTagOf, ... }: {
  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        # lets PipeWire/WirePlumber acquire realtime scheduling
        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          pulse.enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          wireplumber.enable = true;
        };
      };
}
