_:
let
  mkNodeConfig =
    {
      hostName,
      hostId,
      username ? "fkoehler",
      system ? "x86_64-linux",
      timezone ? "Asia/Singapore",
      domain ? "corgi-dojo.ts.net",
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
    };
in
{
  inherit mkNodeConfig;
}
