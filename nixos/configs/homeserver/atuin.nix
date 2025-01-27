_: {
  services.atuin = {
    enable = true;
    openRegistration = true;
    openFirewall = true;
    host = "0.0.0.0";
    maxHistoryLength = 1000000;
    database.createLocally = true;
  };
}
