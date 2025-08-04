{
  config,
  ...
}:
{
  sops.secrets = {
    "email/fastmail/password" = { };
  };
  accounts =
    let
      passwordCommandFastmail = "cat ${config.sops.secrets."email/fastmail/password".path}";
    in
    {
      calendar.accounts."fastmail" = {
        primary = true;
        remote = {
          passwordCommand = passwordCommandFastmail;
          type = "caldav";
          url = "https://caldav.fastmail.com/";
          userName = "fabiankoehler@fastmail.com";
          thunderbird.enable = true;
        };
      };
      contact.accounts."fastmail" = {
        remote = {
          passwordCommand = passwordCommandFastmail;
          type = "carddav";
          url = "https://carddav.fastmail.com/";
          userName = "fabiankoehler@fastmail.com";
          thunderbird.enable = true;
        };
      };
      email.accounts = {
        "fastmail" = {
          address = "fabian@fkoehler.me";
          primary = true;
          realName = "Fabian Koehler";
          userName = "fabiankoehler@fastmail.com";
          passwordCommand = passwordCommandFastmail;
          flavor = "fastmail.com";
          aerc.enable = true;
          thunderbird = {
            enable = true;
          };
        };
        "speqtral" = {
          address = "fabian@speqtral.space";
          realName = "Fabian Koehler";
          flavor = "outlook.office365.com";
          thunderbird = {
            enable = true;
            settings = id: {
              "mail.server.server_${id}.authMethod" = 10;
              "mail.server.smtpserver_${id}.authMethod" = 3;
            };
            messageFilters = [
              {
                name = "Move redmine messages";
                enabled = true;
                type = "17";
                action = "Move to folder";
                actionValue = "imap://fabian%40speqtral.space@outlook.office365.com/INBOX/Redmine";
                condition = "AND (from,is,redmine-noreply@speqtranet.com)";
              }
            ];
          };
        };
      };
    };
  programs = {
    thunderbird = {
      enable = true;
      profiles."default" = {
        isDefault = true;
      };
    };
  };
}
