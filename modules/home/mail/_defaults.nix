{
  pkgs,
  lib,
  service,
  overrides ? { },
}:
let
  inherit (lib) toSentenceCase;
in
{
  ${service} = {
    userName = overrides.${service}.address;
    realName = "Felipe Duarte";

    neomutt = {
      enable = true;
      mailboxName = "${toSentenceCase service}/Caixa de Entrada";
      extraMailboxes = [
        {
          name = "${toSentenceCase service}/Arquivo Morto";
          mailbox = "Arquivo Morto";
        }
        {
          name = "${toSentenceCase service}/Enviados";
          mailbox = overrides.${service}.folders.sent or "Sent";
        }
        {
          name = "${toSentenceCase service}/Rascunhos";
          mailbox = overrides.${service}.folders.drafts or "Drafts";
        }
        {
          name = "${toSentenceCase service}/Excluído";
          mailbox = overrides.${service}.folders.trash or "Trash";
        }
      ];
    };

    offlineimap = {
      enable = true;

      extraConfig.remote = {
        auth_mechanisms = lib.toUpper (overrides.${service}.imap.authentication or "plain");
        createfolders = false;
      };
    };

    imapnotify = {
      enable = true;
      boxes = [ (overrides.${service}.folders.inbox or "Inbox") ];

      onNotify = "${lib.getExe pkgs.offlineimap} -a ${service} -s";
      onNotifyPost = "${lib.getExe' pkgs.libnotify "notify-send"} '[${service}] New mail!'";

      extraArgs = [ "-log-level warn" ];
    };

    msmtp.enable = true;
  };
}
