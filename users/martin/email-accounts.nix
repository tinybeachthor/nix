{ pkgs }:

{
  outlook = rec {
    primary = true;

    address = "toman.martin@live.com";
    realName = "Martin Toman";

    userName = address;
    passwordCommand = "${pkgs.pass}/bin/pass outlook";

    imap = {
      host = "outlook.office365.com";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "smtp.office365.com";
      port = 587;
      tls = {
        enable = true;
        useStartTls = true;
      };
    };

    msmtp.enable = true;
    mbsync = {
      enable = true;
      create = "maildir";
    };
    notmuch.enable = true;
    neomutt.enable = true;
  };
}
