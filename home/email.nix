{pkgs, ...}: {
  accounts.email.accounts = {
    "me@fkoehler.org" = {
      address = "me@fkoehler.org";
      imap = {
        host = "127.0.0.1";
        port = 1143;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      realName = "Fabian Koehler";
      smtp = {
        host = "127.0.0.1";
        port = 1025;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      thunderbird = {
        enable = true;
      };
      userName = "fabian.koehler@proton.me";
      primary = true;
    };
    "fkoehler@physnet.uni-hamburg.de" = {
      address = "fkoehler@physnet.uni-hamburg.de";
      imap = {
        host = "imap.physnet.uni-hamburg.de";
        port = 143;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      realName = "Fabian Koehler";
      smtp = {
        host = "mail.physnet.uni-hamburg.de";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      thunderbird = {
        enable = true;
      };
      userName = "fkoehler";
    };
  };
  programs.thunderbird = {
    enable = true;
    profiles = {
      fkoehler = {
        isDefault = true;
      };
    };
  };
  home.packages = with pkgs; [
    protonmail-bridge-gui
  ];
}
