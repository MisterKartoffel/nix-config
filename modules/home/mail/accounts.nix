{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.modules) secrets;
  inherit (osConfig.modules.services) sops;

  mergeDefaults =
    services: overrides:
    lib.genAttrs services (
      service:
      lib.mkMerge [
        (import ./_defaults.nix {
          inherit
            pkgs
            lib
            secrets
            service
            overrides
            ;
        }).${service}
        overrides.${service}
      ]
    );
in
{
  accounts.email = lib.mkIf sops.enable {
    maildirBasePath = "Mail";

    accounts = mergeDefaults [ "hotmail" "ufrgs" ] {
      hotmail = {
        primary = true;

        maildir.path = "Hotmail";
        folders.trash = "Deleted";

        flavor = "outlook.office365.com";
        imap.authentication = "xoauth2";
        smtp.authentication = "xoauth2";

        passwordCommand = "${lib.getExe pkgs.oama} access ${secrets.hotmail.email}";
      };

      ufrgs = {
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

        passwordCommand = "${lib.getExe' pkgs.coreutils "cat"} ${secrets.ufrgs.password.path}";
      };
    };
  };
}
