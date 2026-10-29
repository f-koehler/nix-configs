{
  config,
  inputs,
  user,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    inherit user;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "deskflow/tap" = inputs.homebrew-deskflow;
    };
    mutableTaps = false;
    trust = {
      formulae = [ ];
      casks = [ ];
      commands = [ ];
      taps = [ ];
    };
  };
  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
}
