{ config, ... }:
let
  inherit (config.accounts.email.accounts) hotmail;
in
{
  accounts.email.accounts.hotmail.imapnotify.extraConfig.xoauth2 =
    hotmail.imap.authentication == "xoauth2";

  services.imapnotify.enable =
    builtins.any (account: account.imapnotify.enable) (
      builtins.attrValues config.accounts.email.accounts
    )
    || config.programs.offlineimap.enable;
}
