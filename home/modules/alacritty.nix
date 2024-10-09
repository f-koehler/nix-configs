{
  isWorkstation,
  isDarwin,
  ...
}: {
  programs.alacritty = {
    enable = isWorkstation;
    settings = {
      font = {
        size =
          if isDarwin
          then 12
          else 9;
        normal = {
          family = "Cascadia Code NF";
          style = "Regular";
        };
        bold = {
          family = "Cascadia Code NF";
          style = "Bold";
        };
        italic = {
          family = "Cascadia Code NF";
          style = "Italic";
        };
        bold_italic = {
          family = "Cascadia Code NF";
          style = "Bold Italic";
        };
      };
    };
  };
}
