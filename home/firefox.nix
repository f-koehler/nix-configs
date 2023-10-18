{ config, ... }: {
  home.file.".var/app/org.mozilla.firefox/.mozilla".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.mozilla";
  programs.firefox = { };
}
