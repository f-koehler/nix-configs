{ config, ... }:
let
  homeManagerApp =
    name: "/Users/${config.system.primaryUser}/Applications/Home Manager Apps/${name}.app";
  homebrewApp = name: "/Applications/${name}.app";
in
{
  system.defaults.dock = {
    autohide = true;
    largesize = 48;
    magnification = true;
    minimize-to-application = true;
    orientation = "bottom";
    persistent-apps = [
      (homeManagerApp "Firefox")
      (homebrewApp "Obsidian")
      (homeManagerApp "KeePassXC")
      (homeManagerApp "Alacritty")
    ];
    show-recents = false;
    tilesize = 32;
  };
}
