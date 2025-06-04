{ nodeConfig, ... }:
{
  programs = {
    git = {
      enable = true;
      userEmail = "fabian.koehler@proton.me";
      userName = "Fabian Koehler";
      signing = {
        key = "C5DC80511469AD81C84E3564D55A35AFB2900A11";
        signByDefault = nodeConfig.isTrusted && nodeConfig.isWorkstation;
      };
      delta.enable = true;
      extraConfig = {
        branch.sort = "-committerdate";
        color.ui = "auto";
        column.ui = "auto";
        commit.verbose = true;
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };
        fetch = {
          all = true;
          prune = true;
          pruneTags = true;
        };
        help.autoCorrect = "prompt";
        init.defaultBranch = "main";
        pull.rebase = "false";
        push = {
          autoSetupRemote = true;
          default = "simple";
          followTags = true;
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        tag.sort = "version:refname";
      };
    };
    lazygit = {
      enable = true;
    };
  };
}
