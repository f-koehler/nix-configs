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
              position = "0,0";
            }
            {
              criteria = "Lenovo Group Limited LEN L27m-28 U45XPDF3";
              mode = "1920x1080";
              position = "0,-1080";
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
              position = "-1920,500";
              scale = 1.5;
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
    ];
  };
}
