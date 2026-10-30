{ pkgs, user, ... }: {
  users.users.${user} = {
    initialPassword = "changeme";
    extraGroups = [
      "i2c"
      "networkmanager"
    ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.fish;
  };
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };
}
