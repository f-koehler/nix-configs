{ pkgs, user, ... }: {
  users = {
    groups.${user} = { };
    users.${user} = {
      isNormalUser = true;
      initialPassword = "changeme";
      group = user;
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
