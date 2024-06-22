_: {
  services.atuin = {
    enable = true;
    openFirewall = true;
    openRegistration = true;
    host = "0.0.0.0";
    maxHistoryLength = 1000000;
    database.createLocally = true;
  };
}
