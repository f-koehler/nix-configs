_: let
  mpdHost = "100.64.220.85";
in {
  services = {
    mpd-mpris = {
      enable = true;
      mpd = {
        host = "${mpdHost}";
        useLocal = false;
      };
    };
  };
  programs.ncmpcpp = {
    enable = true;
    settings = {
      mpd_host = "${mpdHost}";
    };
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
        command = ["select_item" "scroll_down"];
      }
      {
        key = "K";
        command = ["select_item" "scroll_up"];
      }
    ];
  };
}
