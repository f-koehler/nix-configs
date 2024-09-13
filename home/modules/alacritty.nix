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
          family = "Hack Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "Hack Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "Hack Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "Hack Nerd Font";
          style = "Bold Italic";
        };
      };
    };
  };
}
