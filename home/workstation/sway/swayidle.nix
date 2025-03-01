{
  config,
  lib,
  ...
}:
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${lib.getExe' config.programs.swaylock.package "swaylock"} -fF";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${lib.getExe' config.programs.swaylock.package "swaylock"} -fF";
      }
    ];
  };
}
