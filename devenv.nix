{pkgs, ...}: {
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    fastfetch
    git
    just
  ];

  # https://devenv.sh/scripts/
  scripts = {
    refresh.exec = ''
      nix flake update
      devenv update
    '';
    rebuild.exec = ''
      if [ "$(uname)" == "Darwin" ]; then
        nix run nix-darwin -- switch --flake .
        nix run home-manager -- switch --flake .
      else
        nix-shell -p nh --run "nh os boot ."
        nix-shell -p nh --run "nh home switch ."
      fi
    '';
  };

  enterShell = ''
    ${pkgs.fastfetch}/bin/fastfetch

    # Custom greeting message with color
    echo -e "\033[1;32mWelcome to the development environment, Fabian!\033[0m"

    # Display two commonly used commands with color
    echo ""
    echo -e "\033[1;34mUseful commands:\033[0m"
    echo -e "\033[1;36m  1. refresh  - \033[0m\033[0;33m🔄 Updates nix flake & devenv\033[0m"
    echo -e "\033[1;36m  2. rebuild  - \033[0m\033[0;33m🏗️  Rebuilds and switches system and user config\033[0m"
    echo ""
  '';

  # # https://devenv.sh/tests/
  # enterTest = ''
  #   echo "Running tests"
  #   git --version | grep "2.42.0"
  # '';

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
