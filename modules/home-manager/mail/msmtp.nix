{
  config,
  lib,
  ...
}:
let
  inherit (config.accounts.email.accounts) hotmail;
in
{
  accounts.email.accounts.hotmail.msmtp.extraConfig.auth =
    lib.mkIf hotmail.msmtp.enable hotmail.smtp.authentication;

  programs.msmtp.enable = lib.any (account: account.msmtp.enable) (
    lib.attrValues config.accounts.email.accounts
  );
}
