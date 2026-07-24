{ config, pkgs, ... }:
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

  home.packages = [
    (pkgs.writeShellApplication {
      name = "s3-bucket-sizes";
      runtimeInputs = with pkgs; [
        awscli2
        coreutils
        gawk
        util-linux
      ];
      text = ''
        declare -a rows=()
        total_bytes=0

        for bucket in $(aws s3api list-buckets --query "Buckets[].Name" --output text); do
            summary=$(aws s3 ls "s3://$bucket" --recursive --summarize 2>/dev/null | tail -n 2)
            objects=$(awk -F': ' '/Total Objects/{print $2}' <<<"$summary")
            bytes=$(awk -F': ' '/Total Size/{print $2}' <<<"$summary")
            objects=''${objects:-0}
            bytes=''${bytes:-0}

            total_bytes=$((total_bytes + bytes))
            human=$(numfmt --to=iec-i --suffix=B --format="%.2f" "$bytes")

            rows+=("$bucket|$objects|$human")
        done

        {
            echo "Bucket|Objects|Size"
            printf '%s\n' "''${rows[@]}"
        } | column -t -s '|'

        echo
        echo "Total: $(numfmt --to=iec-i --suffix=B --format="%.2f" "$total_bytes") across ''${#rows[@]} buckets"
      '';
    })
  ];
}
