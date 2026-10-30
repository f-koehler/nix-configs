{
  lib,
  config,
  hasAnyTagOf,
  hasTag,
  ...
}:
{
  config =
    lib.mkIf
      (hasAnyTagOf [
        "desktop"
        "laptop"
      ])
      {
        sops = {
          secrets."accounts/fastmail/dav_password".sopsFile = ./../secrets/personal.yaml;
          secrets."accounts/speqtral/calendar_url".sopsFile = ./../secrets/personal.yaml;
        };
        accounts = {
          calendar = {
            basePath = ".local/state/calendars";
            accounts."fastmail" = {
              primary = true;
              remote = {
                type = "caldav";
                url = "https://caldav.fastmail.com/";
                userName = "fabiankoehler@fastmail.com";
                passwordCommand = [
                  "cat"
                  config.sops.secrets."accounts/fastmail/dav_password".path
                ];
              };
              noctalia.enable = true;
              thunderbird.enable = true;
              vdirsyncer = {
                enable = true;
                collections = [
                  "from a"
                  "from b"
                ];
              };
            };
          };
          calendar.accounts."speqtral" = {
            remote.type = "http";
            noctalia.enable = true;
            thunderbird.enable = true;
            vdirsyncer = {
              enable = true;
              urlCommand = [
                "cat"
                config.sops.secrets."accounts/speqtral/calendar_url".path
              ];
            };
          };
          contact = {
            basePath = ".local/state/contacts";
            accounts."fastmail" = {
              remote = {
                type = "carddav";
                url = "https://carddav.fastmail.com/";
                userName = "fabiankoehler@fastmail.com";
                passwordCommand = [
                  "cat"
                  config.sops.secrets."accounts/fastmail/dav_password".path
                ];
              };
              thunderbird.enable = true;
              vdirsyncer = {
                enable = true;
                collections = [
                  "from a"
                  "from b"
                ];
              };
            };
          };
          email.accounts = {
            "fastmail" = {
              address = "fabian@fkoehler.me";
              primary = true;
              realName = "Fabian Koehler";
              userName = "fabiankoehler@fastmail.com";
              flavor = "fastmail.com";
              aerc.enable = true;
              passwordCommand = [
                "cat"
                config.sops.secrets."accounts/fastmail/dav_password".path
              ];
              thunderbird = {
                enable = true;
              };
            };
            "speqtral" = lib.mkIf (hasTag "speqtral") {
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
          vdirsyncer.enable = true;
        };
        services = {
          vdirsyncer.enable = true;
        };
      };
}
