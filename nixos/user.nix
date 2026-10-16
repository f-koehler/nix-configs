{ pkgs, ... }: {
  users = {
    groups.fkoehler = { };
    users.fkoehler = {
      isNormalUser = true;
      group = "fkoehler";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        tree
      ];
      shell = pkgs.zsh;
    };
  };
  programs.zsh.enable = true;
}
