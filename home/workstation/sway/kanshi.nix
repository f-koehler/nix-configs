_: {
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "work";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1200";
              position = "2560,-1000";
            }
            {
              criteria = "Dell Inc. DELL S2722DC 82CRGD3";
              mode = "2560x1440@75";
              position = "0,0";
            }
          ];
        };
      }
      {
        profile = {
          name = "home";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1200";
              position = "320,1440";
              scale = 1.0;
            }
            {
              criteria = "LG Electronics LG ULTRAGEAR+ 202NTDV2S306";
              mode = "3840x2160@120";
              position = "0,0";
              scale = 1.5;
            }
          ];
        };
      }
      {
        profile = {
          name = "mobile";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "1920x1200";
              position = "0,0";
              scale = 1.0;
            }
          ];
        };
      }
    ];
  };
}
