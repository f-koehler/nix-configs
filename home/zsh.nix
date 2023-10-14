{ ... }: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 1000000;
      share = true;
      size = 1000000;
    };
    initExtra = ''
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[3~" delete-char
      bindkey "^[[1;3D" backward-word
      bindkey "^[[1;3C" forward-word

      export GPG_TTY=$(tty)
      if [[ "$OSTYPE" == "darwin"* ]]; then
        eval $(/opt/homebrew/bin/brew shellenv)
        export FPATH=\"/opt/homebrew/share/zsh/site-functions:''${FPATH}\"
        eval "$(/usr/libexec/path_helper)"
      fi

      eval "$(micromamba shell hook --shell=zsh)"
    '';
  };
}
