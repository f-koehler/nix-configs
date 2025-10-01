{ nodeConfig, ... }:
{
  nixpkgs = {
    hostPlatform = nodeConfig.system;
  };
  users = {
    groups.${nodeConfig.username} = { };
    users.${nodeConfig.username} = {
      isNormalUser = true;
      group = "${nodeConfig.username}";
      extraGroups = [ "wheel" ];
    };
  };
  time.timeZone = nodeConfig.timezone;
}
