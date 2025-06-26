{
  inputs,
  pkgs,
  nodeConfig,
  ...
}:
let
  spicePkgs = inputs.spicetify.legacyPackages.${nodeConfig.system};
in
{
  imports = [ inputs.spicetify.homeManagerModules.spicetify ];
  home.packages = [
    pkgs.spotify
  ];
  programs.spicetify = {
    # enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      copyToClipboard
      betterGenres
      shuffle
      hidePodcasts
    ];
  };
  stylix.targets.spicetify.enable = true;
}
