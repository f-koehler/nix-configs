_: {
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
    setOptions = [ "NO_BEEP" ];
    syntaxHighlighting.enable = true;
  };
}
