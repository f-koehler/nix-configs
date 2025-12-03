{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    signing = {
      format = "openpgp";
      key = "C5DC80511469AD81C84E3564D55A35AFB2900A11";
      signByDefault = true;
    };
    settings = {
      fetch = {
        all = true;
        prune = true;
        pruneTags = true;
      };
      help.autoCorrect = "prompt";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      user = {
        email = "fabian@fkoehler.me";
        name = "Fabian Koehler";
      };
    };
  };
}
