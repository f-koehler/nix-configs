{ pkgs, ... }: {
  users = {
    groups.fkoehler = { };
    users.fkoehler = {
      isNormalUser = true;
      initialPassword = "changeme";
      group = "fkoehler";
      extraGroups = [
        "i2c"
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        tree
      ];
      shell = pkgs.fish;
    };
  };
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };
}
