{
  lib,
  pkgs,
  config,
  nodeConfig,
  ...
}:
lib.mkIf nodeConfig.isTrusted {
  sops.secrets = {
    "aws/key_id".path = "${config.home.homeDirectory}/.local/share/aws/key_id";
    "aws/key".path = "${config.home.homeDirectory}/.local/share/aws/key";
  };
  home.packages = let
    awscli-wrapped = pkgs.writeShellScriptBin "aws" ''
      export AWS_ACCESS_KEY_ID=$(cat ${config.sops.secrets."aws/key_id".path})
      export AWS_SECRET_ACCESS_KEY=$(cat ${config.sops.secrets."aws/key".path})
      ${pkgs.awscli}/bin/aws "$@"
    '';
  in [awscli-wrapped];
}
