{ pkgs, ... }:
{
  services.kmscon = {
    enable = false;
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
