{
  lib,
  isLinux,
  ...
}:
lib.mkIf isLinux {
  programs.plasma = {
    configFile = {
      kwinrc = {
        Windows = {
          ActiveMouseScreen = false;
          SeparateScreenFocus = true;
        };
      };
    };
    window-rules = [
      {
        description = "Krohnkite: Set Minimum Geometry Size";
        match = {
          window-types = ["normal"];
        };
        apply."minsize" = {
          apply = "force";
          value = 2;
        };
      }
    ];
  };
}
