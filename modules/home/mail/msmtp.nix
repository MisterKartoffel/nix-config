{ config, ... }:
let
  inherit (config.accounts.email.accounts) hotmail;
in
{
  accounts.email.accounts.hotmail.msmtp.extraConfig.auth = hotmail.smtp.authentication;

  programs.msmtp.enable = builtins.any (account: account.msmtp.enable) (
    builtins.attrValues config.accounts.email.accounts
  );
}
