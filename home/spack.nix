_: {
  programs = {
    bash.initExtra = ''
      if [ -f "$HOME/spack/share/spack/setup-env.sh" ]; then
        . "$HOME/spack/share/spack/setup-env.sh"
      fi
    '';

    zsh.initContent = ''
      if [ -f "$HOME/spack/share/spack/setup-env.sh" ]; then
        . "$HOME/spack/share/spack/setup-env.sh"
      fi
    '';

    fish.interactiveShellInit = ''
      if test -f "$HOME/spack/share/spack/setup-env.fish"
        source "$HOME/spack/share/spack/setup-env.fish"
      end
    '';
  };
}
