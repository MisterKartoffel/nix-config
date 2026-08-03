{ config, ... }:
let
  xdg.cache = config.xdg.cache.directory;
in
{
  xdg.config.files."neomutt/folder-hook/hotmail".text = /* muttrc */ ''
    set folder = "imaps://outlook.office365.com/"
    set from = "felipesdrs@hotmail.com"

    set spool_file = +Inbox
    set postponed = +Drafts
    set trash = +Deleted

    set header_cache = ${xdg.cache}/neomutt/hotmail/header
    set message_cache_dir = ${xdg.cache}/neomutt/hotmail/message
  '';
}
