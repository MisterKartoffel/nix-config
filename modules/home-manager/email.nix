{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.home) homeDirectory;
  inherit (config.modules.secrets) name hotmail;
  inherit (osConfig.modules.services) sops;
in
{
  accounts.email = lib.mkIf sops.enable {
    maildirBasePath = "${homeDirectory}/Mail";

    accounts = {
      ${hotmail.email} = {
        primary = true;

        address = hotmail.email;
        userName = hotmail.email;
        realName = name;

        maildir.path = "Hotmail";
        folders.trash = "Deleted";

        flavor = "outlook.office365.com";
        imap.authentication = "xoauth2";
        smtp.authentication = "xoauth2";
        smtp.host = lib.mkForce "smtp-mail.office365.com";
        passwordCommand = "${lib.getExe pkgs.oama} access ${hotmail.email}";
      };
    };
  };
}
