{ lib, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;
    autosuggestion.enable = true;
    history = {
      append = true;
      expireDuplicatesFirst = true;
      extended = true;
      findNoDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      save = 100000;
      saveNoDups = true;
      share = true;
      size = 100000;
    };
    historySubstringSearch.enable = true;
    initContent = lib.mkMerge [
      (lib.mkOrder 1000 ''
        bindkey "^[[1;9D" backward-word
        bindkey "^[[1;9C" forward-word
      '')
    ];
    setOptions = [ "NO_BEEP" ];
    syntaxHighlighting.enable = true;
  };

}
