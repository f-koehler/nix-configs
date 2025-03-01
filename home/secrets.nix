{
  lib,
  config,
  nodeConfig,
  ...
}:
{
  sops = lib.mkIf nodeConfig.isTrusted {
    age = {
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      generateKey = false;
    };
    defaultSopsFile = ../secrets/home.yaml;
  };
}
