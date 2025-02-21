{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    extraOptions = "--term xterm-256color";
    hwRender = true;
    fonts = [
      {
        name = "Cascadia Code NF";
        package = pkgs.cascadia-code;
      }
    ];
  };
}
