{ user, ... }: {
  users = {
    groups.${user} = { };
    users.${user} = {
      isNormalUser = true;
      group = user;
      extraGroups = [ "wheel" ];
    };
  };
}
