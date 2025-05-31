{
  lib,
  pkgs,
  config,
  nodeConfig,
  ...
}:
{
  sops.secrets = {
    "aws/key_id".path = "${config.home.homeDirectory}/.local/share/aws/key_id";
    "aws/key".path = "${config.home.homeDirectory}/.local/share/aws/key";
  };
  programs.awscli = {
    enable = true;
    package =
      if nodeConfig.isTrusted then
        pkgs.writeShellScriptBin "aws" ''
          export AWS_ACCESS_KEY_ID=$(cat ${config.sops.secrets."aws/key_id".path})
          export AWS_SECRET_ACCESS_KEY=$(cat ${config.sops.secrets."aws/key".path})
          ${lib.getExe' pkgs.awscli2 "aws"} "$@"
        ''
      else
        pkgs.awscli2;
  };
}
