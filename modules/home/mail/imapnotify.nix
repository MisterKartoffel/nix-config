{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.accounts.email.accounts) hotmail ufrgs;
in
{
  accounts.email.accounts = {
    hotmail.imapnotify = lib.mkIf hotmail.imapnotify.enable {
      onNotify = "${lib.getExe pkgs.offlineimap} -a hotmail";
      onNotifyPost = "${pkgs.libnotify}/bin/notify-send 'New mail!'";

      boxes = [
        "Inbox"
        "Arquivo Morto"
        "Sent"
        "Drafts"
        "Deleted"
        "Junk"
      ];
    };

    ufrgs.imapnotify = lib.mkIf ufrgs.imapnotify.enable {
      onNotify = "${lib.getExe pkgs.offlineimap} -a ufrgs";
      onNotifyPost = "${pkgs.libnotify}/bin/notify-send 'New mail!'";

      boxes = [
        "INBOX"
        "Arquivo Morto"
        "Sent"
        "Drafts"
        "Trash"
        "Spam"
      ];
    };
  };

  services.imapnotify.enable = lib.any (account: account.imapnotify.enable) (
    lib.attrValues config.accounts.email.accounts
  );
}
