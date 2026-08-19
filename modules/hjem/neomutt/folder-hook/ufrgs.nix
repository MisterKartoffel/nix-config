{ config, ... }:
let
  xdg.cache = config.xdg.cache.directory;
in
{
  xdg.config.files."neomutt/folder-hook/ufrgs".text = /* muttrc */ ''
    set folder = "imaps://imap.ufrgs.br/"
    set from = "00288910@ufrgs.br"

    set spool_file = +INBOX
    set postponed = +Drafts
    set trash = +Trash

    set header_cache = ${xdg.cache}/neomutt/ufrgs/header
    set message_cache_dir = ${xdg.cache}/neomutt/ufrgs/message
  '';
}
