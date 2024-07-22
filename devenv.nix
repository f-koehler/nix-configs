{pkgs, ...}: {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [pkgs.git];

  # https://devenv.sh/scripts/
  scripts.hello.exec = "echo hello from $GREET";

  enterShell = ''
    hello
    git --version
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep "2.42.0"
  '';

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/languages/
  languages.nix.enable = true;

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    check-added-large-files.enable = true;
    check-executables-have-shebangs.enable = true;
    check-merge-conflicts.enable = true;
    check-symlinks.enable = true;
    # end-of-line-fixer.enable = true;
    # trim-trailing-whitespace = true;
    # end-of-file-fixer = true;

    # nix
    alejandra.enable = true;
    deadnix.enable = true;
    flake-checker.enable = true;
    nil.enable = true;
    statix.enable = true;

    # shell
    shellcheck.enable = true;
    shfmt.enable = true;

    # yaml
    yamllint.enable = true;

    # toml
    taplo.enable = true;

    # other
    prettier.enable = true;
    actionlint.enable = true;
  };

  # https://devenv.sh/processes/
  # processes.ping.exec = "ping example.com";

  # See full reference at https://devenv.sh/reference/options/
}
