{
  lib,
  isLinux,
  nodeConfig,
  ...
}:
lib.mkIf isLinux {
  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/${nodeConfig.username}/Network/media1/soundtracks";
      network = {
        startWhenNeeded = true;
      };
    };
    mpd-mpris = {
      enable = true;
    };
  };
  programs.ncmpcpp = {
    enable = true;
    bindings = [
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "J";
        command = [
          "select_item"
          "scroll_down"
        ];
      }
      {
        key = "K";
        command = [
          "select_item"
          "scroll_up"
        ];
      }
    ];
  };
}
