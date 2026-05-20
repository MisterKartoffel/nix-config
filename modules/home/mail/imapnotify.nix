{
  config,
  lib,
  ...
}:
let
  inherit (config.accounts.email.accounts) hotmail;
in
{
  accounts.email.accounts = {
    hotmail.imapnotify = lib.mkIf hotmail.imapnotify.enable {
      extraConfig = {
        xoauth2 = hotmail.imap.authentication == "xoauth2";
      };
    };
  };

  services.imapnotify.enable = lib.any (account: account.imapnotify.enable) (
    lib.attrValues config.accounts.email.accounts
  );
}
