_:
let
  mkDefaultFeatures = {
    audiobookshelf.enable = false;
    navidrome.enable = false;
  };
  mkNodeConfig =
    {
      hostName,
      hostId,
      username ? "fkoehler",
      system ? "x86_64-linux",
      timezone ? "Asia/Singapore",
      domain ? "corgi-dojo.ts.net",
      features ? { },
    }:
    {
      inherit
        domain
        hostId
        hostName
        system
        timezone
        username
        ;
      features = mkDefaultFeatures // features;
    };
in
{
  inherit mkNodeConfig;
}
