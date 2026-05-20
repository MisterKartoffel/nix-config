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
    hotmail.msmtp = lib.mkIf hotmail.msmtp.enable {
      extraConfig.auth = hotmail.smtp.authentication;
    };
  };

  programs.msmtp.enable = lib.any (account: account.msmtp.enable) (
    lib.attrValues config.accounts.email.accounts
  );
}
