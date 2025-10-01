_:
let
  mkNodeConfig =
    {
      hostname,
      username ? "fkoehler",
      system ? "x86_64-linux",
      timezone ? "Asia/Singapore",
    }:
    {
      inherit
        hostname
        system
        timezone
        username
        ;
    };
in
{
  inherit mkNodeConfig;
}
