{ config, ... }:
{
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      "aws/key_id" = {
        sopsFile = ./../secrets/speqtral.yaml;
      };
      "aws/secret_key" = {
        sopsFile = ./../secrets/speqtral.yaml;
      };
    };
    templates = {
      "aws-credentials" = {
        content = ''
          [default]
          aws_access_key_id = ${config.sops.placeholder."aws/key_id"}
          aws_secret_access_key = ${config.sops.placeholder."aws/secret_key"}
        '';
      };
    };
  };

  programs.awscli = {
    enable = true;
    settings = {
      default = {
        region = "ap-southeast-1";
      };
    };
  };
  home.file = {
    ".aws/credentials" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.sops.templates."aws-credentials".path}";
    };
  };
}
