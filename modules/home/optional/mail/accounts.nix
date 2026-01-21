{ config, ... }:
let
  inherit (config.secrets) name email;
in
{
  accounts.email.accounts = {
    ${email.hotmail.email} = {
      primary = true;

      address = email.hotmail.email;
      userName = email.hotmail.email;
      realName = name;

      imap = {
        authentication = "xoauth2";
        host = "outlook.office365.com";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        authentication = "xoauth2";
        host = "smtp-mail.office365.com";
        port = 587;
        tls.enable = true;
        tls.useStartTls = true;
      };
    };
  };
}
