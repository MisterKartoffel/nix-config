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
            service
            overrides
            ;
        }).${service}
        overrides.${service}
      ]
    );
in
{
  assertions = [
    {
      assertion =
        lib.any (account: account.enable) (builtins.attrValues config.accounts.email.accounts)
        -> sops.enable;

      message = "Mail account configuration requires sops-nix to be enabled.";
    }
  ];

  accounts.email = {
    maildirBasePath = "Mail";

    accounts = mergeDefaults [ "hotmail" "ufrgs" ] {
      hotmail = rec {
        primary = true;
        address = "felipesdrs@hotmail.com";

        maildir.path = "Hotmail";
        folders.trash = "Deleted";

        flavor = "outlook.office365.com";
        imap.authentication = "xoauth2";
        smtp.authentication = "xoauth2";

        passwordCommand = "${lib.getExe pkgs.oama} access ${address}";
      };

      ufrgs = {
        address = "00288910@ufrgs.br";

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
