_: {
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>Neotree<CR>";
        key = "-";
        options = {
          silent = true;
        };
      }
    ];
    plugins.neo-tree = {
      enable = true;
      autoCleanAfterSessionRestore = true;
      closeIfLastWindow = true;
      defaultSource = "filesystem";
      gitStatusAsync = true;
      filesystem = {
        bindToCwd = true;
        hijackNetrwBehavior = "open_default";
        followCurrentFile = {
          enabled = true;
          leaveDirsOpen = false;
        };
      };
    };
  };
}
