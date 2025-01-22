_: {
  programs.nixvim.plugins.neotest = {
    enable = true;
    adapters = {
      python.enable = true;
      rust.enable = true;
    };
  };
}
