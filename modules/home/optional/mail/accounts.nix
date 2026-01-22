{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.secrets) name;
  inherit (config.secrets.email.hotmail) email;
in {
  accounts.email = {
    maildirBasePath = "${config.home.homeDirectory}/Mail";

    accounts = {
      ${email} = {
        primary = true;

        address = email;
        userName = email;
        realName = name;

        maildir.path = "Hotmail";
        folders.trash = "Deleted";

        flavor = "outlook.office365.com";
        imap.authentication = "xoauth2";
        smtp.authentication = "xoauth2";
        smtp.host = lib.mkForce "smtp-mail.office365.com";
        passwordCommand = "${pkgs.oama}/bin/oama access ${email}";
      };
    };
  };
}
