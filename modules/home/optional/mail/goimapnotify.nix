{
  config,
  pkgs,
  ...
}: let
  inherit (config.secrets.email.hotmail) email;
in {
  accounts.email.accounts.${email}.imapnotify = {
    enable = true;

    boxes = [
      "Inbox"
      "Arquivo Morto"
      "Sent"
      "Drafts"
      "Deleted"
      "Junk"
    ];

    onNotify = "${pkgs.offlineimap}/bin/offlineimap -a ${email} -u quiet";

    extraConfig = {
      xoAuth2 = true;
    };
  };

  services.imapnotify = {
    enable = true;
  };
}
