{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.modules.secrets) name hotmail ufrgs;
  inherit (osConfig.modules.services) sops;
in
{
  accounts.email = lib.mkIf sops.enable {
    maildirBasePath = "Mail";

    accounts = {
      hotmail = {
        enable = true;
        primary = true;

        address = hotmail.email;
        userName = hotmail.email;
        realName = name;

        maildir.path = "Hotmail";
        folders.trash = "Deleted";

        flavor = "outlook.office365.com";
        imap.authentication = "xoauth2";
        smtp.authentication = "xoauth2";

        passwordCommand = "${lib.getExe pkgs.oama} access ${hotmail.email}";

        neomutt.enable = true;
        offlineimap.enable = true;
        imapnotify.enable = true;
        msmtp.enable = true;
      };

      ufrgs = {
        enable = true;

        address = ufrgs.email;
        userName = ufrgs.email;
        realName = name;

        maildir.path = "UFRGS";
        folders.inbox = "INBOX";

        imap = {
          host = "imap.ufrgs.br";
          authentication = "plain";
        };

        smtp = {
          host = "smtp.ufrgs.br";
          port = 587;
          authentication = "plain";
          tls.useStartTls = true;
        };

        passwordCommand = "${pkgs.coreutils}/bin/cat ${ufrgs.password.path}";

        neomutt.enable = true;
        offlineimap.enable = true;
        imapnotify.enable = true;
        msmtp.enable = true;
      };
    };
  };
}
