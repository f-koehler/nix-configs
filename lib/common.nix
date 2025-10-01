_:
let
  mkNodeConfig =
    {
      hostname,
      username ? "fkoehler",
      system ? "x86_64-linux",
    }:
    {
      inherit hostname username system;
    };
in
{
  inherit mkNodeConfig;
}
