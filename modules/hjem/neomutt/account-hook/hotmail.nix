{ pkgs, lib, ... }: {
  xdg.config.files."neomutt/account-hook/hotmail".text = /* muttrc */ ''
    set folder = "imaps://outlook.office365.com/"
    set imap_user = "felipesdrs@hotmail.com"
    set imap_authenticators = "xoauth2"
    set imap_oauth_refresh_command = "${lib.getExe pkgs.oama} access felipesdrs@hotmail.com"

    set spool_file = +Inbox
    set record = +Sent
    set postponed = +Drafts
    set trash = +Deleted
  '';
}
