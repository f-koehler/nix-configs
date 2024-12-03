{
  pkgs,
  username,
  ...
}: {
  users = {
    groups."${username}" = {};
    users."${username}" = {
      isNormalUser = true;
      description = "Fabian Koehler";
      group = "${username}";
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
    };
  };
  programs.zsh.enable = true;
}
