{ config, pkgs, ... }:
let
  xdg.config = config.xdg.config.directory;
in
{
  packages = builtins.attrValues { inherit (pkgs) neomutt; };

  xdg.config.files."neomutt/neomuttrc".text = ''
    account-hook outlook.office365.com "source account-hook/hotmail"
    account-hook imap.ufrgs.br "source account-hook/ufrgs"

    named-mailboxes "Hotmail/Caixa de Entrada" "imaps://outlook.office365.com/Inbox" \
    								"Hotmail/Arquivo Morto" "imaps://outlook.office365.com/Arquivo Morto" \
    								"Hotmail/Lixeira" "imaps://outlook.office365.com/Deleted" \
    								"Hotmail/Rascunhos" "imaps://outlook.office365.com/Drafts" \
    								"Hotmail/Enviados" "imaps://outlook.office365.com/Sent" \
    								"Hotmail/Lixo Eletrônico" "imaps://outlook.office365.com/Junk"
    								# "UFRGS/Caixa de Entrada" "imaps://imap.ufrgs.br/INBOX" \
    								# "UFRGS/Arquivo Morto" "imaps://imap.ufrgs.br/Arquivo Morto" \
    								# "UFRGS/Lixeira" "imaps://imap.ufrgs.br/Trash" \
    								# "UFRGS/Rascunhos" "imaps://imap.ufrgs.br/Drafts" \
    								# "UFRGS/Enviados" "imaps://imap.ufrgs.br/Sent" \
    								# "UFRGS/Lixo Eletrônico" "imaps://imap.ufrgs.br/Spam"

    folder-hook outlook.office365.com "source folder-hook/hotmail"
    # folder-hook imap.ufrgs.br "source folder-hook/ufrgs"

    send-hook ~P "source send-hook/hotmail"

    set mailcap_path = "${xdg.config}/neomutt/mailcap"
    set new_mail_command = "notify-send \"New e-mail\!\" \"New: %n.\nUnread: %u.\" --app-name=\"NeoMutt\""

    ignore *
    unignore subject: from: to: cc: date:
    hdr_order subject: from: to: cc: date:

    alternative_order text/html text/*

    set mail_check_stats
    set imap_condstore
    set imap_qresync
    set imap_idle
    set implicit_auto_view
    set use_threads = threads
    set sort = reverse-last-date
    set sort_browser = unsorted
    set delete = yes
    set nomarkers

    source keybinds
    source style
  '';
}
